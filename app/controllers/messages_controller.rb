class MessagesController < ApplicationController
  before_action :authorize, :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|

      # VALIDATION FOR THE MESSAGE GOES HERE
      errors = []

      # validate msg length
      if @message.body.length < 1
        errors << t("message_is_empty")
      end

      if !errors.any?
        # NO ERRORS LETS GIVE SOME TOUCHES AND SAVE
        @message.moderated = false

        if @message.save
          # socket broadcast
          ChatChannel.broadcast_to @message.chat_id, message: @message

          format.html do
            flash[:success] = t("message_ok")
            redirect_to "#{chat_path}/#{@message.chat_id}"
          end
          format.json { render :show, status: :created, location: @message }

          format.js do
            @newMessage = @message
          end

        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      else
        # THERE WAS AT LEAST 1 ERROR
        flash[:danger] = ""
        errors.each do |message|
          flash[:danger] << "#{message}<br>"
        end
        format.html {render chat_path}
      end


    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.permit(:user_id, :chat_id, :body, :moderated)
    end
end
