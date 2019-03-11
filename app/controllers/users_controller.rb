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
      # validate username
      errors << validateUsername(@user.username)
      # PASSWORD VALIDATION
      errors << validatePassword(@user.password, @user.password_confirmation)
      # VALIDATIONS ARE OVER >> LETS CHECK IF THERE ANY ERRORS AND RESPOND
      if errors.any? == false
        # NO ERRORS >> SAVE USER
        if @user.save
          format.html do
            flash[:success] = t("account_created")
            redirect_to login_path
          end
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


  def update_password
    # init shit
    errors = []
    # validate password
    errors << validatePassword(params[:user][:new_password], params[:user][:new_password_confirmation])
    # authenticate user
    if !@user.authenticate(params[:user][:password])
      errors << t("validate_password_fail")
    end

    # VALIDATION END >> lets proceed
    if errors.any? == false
      # replace password
      @user.password_digest = BCrypt::Password.create(params[:user][:new_password])
      # no errors > go
      respond_to do |format|

        if @user.save(user_params)
          # process OK
          format.html do
            redirect_to logout_path
          end
        else
          # process NOT OK
          flash[:danger] = "Nope"
          redirect_to account_path
        end

      end
    else
      # with errors > deliver alert
      flash[:danger] = ""
      errors.each do |message|
        flash[:danger] << "#{message}<br>"
      end
      redirect_to account_path
    end

  end
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    # init errors array
    errors = []
    # validate username
    errors << validateUsername(params[:user][:username])
    # validate user authentication
    if !@user.authenticate(params[:user][:password])
      errors << t("validate_password_fail")
    end
    # validate errors emptiness.
    if errors.any? == false
      # NO ERRORS > PROCEED
      respond_to do |format|
        if @user.update(user_params)
          format.html do
            # everything was ok > lets deliver
            flash[:success] = t("account_updated")
            redirect_to account_path

          end
          format.json { render :show, status: :ok, location: @user }
        else
          format.html do
            # user was not updated
          end
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      # ERRORS > launch errors
      flash[:danger] = ""
      errors.each do |message|
        flash[:danger] << "#{message}<br>"
      end
      redirect_to account_path
    end

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # init errors array
    errors = []
    # validate user authentication
    if !@user.authenticate(params[:user][:password])
      errors << t("validate_password_fail")
    end
    # validate errors emptiness.
    if errors.any? == false
      # NO ERRORS
      # User messages destroy
      msgTrash = Message.where(user_id: @user.id)
      msgTrash.delete_all
      # User destroy
      @user.destroy
      respond_to do |format|
        format.html do

          session[:user_id] = nil
          flash[:success] = t("account_deleted")
          redirect_to root_path

        end
        format.json { head :no_content }
      end

    else
      # ERRORS
      # with errors > deliver alert
      flash[:danger] = ""
      errors.each do |message|
        flash[:danger] << "#{message}<br>"
      end
      redirect_to account_path
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :password_digest, :new_password, :new_password_confirmation)
    end

    # DRY username validation
    def validateUsername(username)
      errors = []
      # USER VALIDATION
      # Lets validate username regex
      if username !~ /\A[a-z0-9\-_]+\z/i
        errors << "#{t("invalid_username")}<br>"
      end

      # Lets validate username length
      if username.length < 4 || username.length > 16
          errors << "#{t("username_length_error")}<br>"
      end

      # Lets validate username availability existance
      # lets give a pre-error-check to avoid this request if not needed.
      if errors.any? == false
        if User.where(username: username).count > 0
          puts "DEBUG >> #{User.where(username: username).count()}"
          puts "DEBUG >> #{username}"
            errors << "#{t("username_taken")}<br>"
        end
      end
      # return array of errors if any. If not returns empty array
      if errors.any?
        return errors
      end

    end

    # DRY password validation
    def validatePassword(password, password_2)
      errors = []
      # lets validate password length
      if password.length < 4 || password.length > 32
          errors << "#{t("password_length_error")}<br>"
      end

      # lets compare the password
      if password != password_2
        errors << "#{t("password_do_not_match")}<br>"
      end

      if errors.any?
        return errors
      end

    end

end
