class UsersController < ApplicationController
  before_action :authorize, :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create


    @user = User.new(user_params)

    respond_to do |format|
      # init errors
      errors = []
      # USER VALIDATION
      # Lets validate username regex
      if @user.username !~ /\A[a-z0-9\-_]+\z/i
        errors << "#{t("invalid_username")}<br>"
      end

      # Lets validate username length
      if @user.username.length < 4 || @user.username.length > 16
          errors << "#{t("username_length_error")}<br>"
      end

      # Lets validate username availability existance
      # lets give a pre-error-check to avoid this request if not needed.
      if errors.any? == false
        if User.where(username: @user.username).count() > 0
            errors << "#{t("username_taken")}<br>"
        end
      end

      # END OF USER VALIDATION

      # PASSWORD VALIDATION
      # lets validate password length
      if @user.password.length < 4 || @user.password.length > 32
          errors << "#{t("password_length_error")}<br>"
      end

      # lets compare the password
      if @user.password != @user.password_confirmation
        errors << "#{t("password_do_not_match")}<br>"
      end


      # VALIDATIONS ARE OVER >> LETS CHECK IF THERE ANY ERRORS AND RESPOND
      if errors.any? == false
        # NO ERRORS >> SAVE USER
        if @user.save
          format.html { redirect_to chat_path, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html do
            flash[:danger] = t("account_not_created")
            render :new
          end
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        # THERE WAS AT LEAST 1 ERROR
        flash[:danger] = ""
        errors.each do |message|
          flash[:danger] << "#{message}<br>"
        end
        format.html {redirect_to signup_path}
      end

    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :password_digest)
    end
end
