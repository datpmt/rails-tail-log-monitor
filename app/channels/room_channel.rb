class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # Rails.logger.info "Subscriber #{current_user.id} has unsubscribed from MyChannel."
  end
end
