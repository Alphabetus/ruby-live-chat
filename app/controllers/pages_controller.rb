class PagesController < ApplicationController

  def index
    if isLogged?
      redirect_to chat_path
    end
  end


  # OK LETS HANDLE THE CHAT ROOMS
  def chat

    # chatroom list
    @rooms = [
      "Global",
      "WebDev",
      "UxDesign",
      "UiDesign",
      "Humour"
    ]

    # check existent param over select room and give index position, otherwise room is int 0.
    if params.has_key?(:chat)
      @room = params[:chat]
    else
      @room = 0
    end
    @messages = Message.where(chat_id: @room).order(created_at: :desc).limit(15).reverse
    @url = "/chat/#{@room}"


  end

end
