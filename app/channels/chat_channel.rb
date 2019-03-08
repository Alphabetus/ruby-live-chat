class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_for "channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
