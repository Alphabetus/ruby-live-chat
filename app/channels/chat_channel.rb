class ChatChannel < ApplicationCable::Channel
  def subscribed

    # stream_from "chat"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end


  def listen(chatID)
    puts "IVE RUNNED"
    # stop_all_streams
    stream_for "#{chatID["chat"]}"
  end


end
