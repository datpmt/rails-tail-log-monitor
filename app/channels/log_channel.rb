# frozen_string_literal: true

class LogChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'log_channel'
  end

  def keep_alive
    $monitoring_keep_alive = Time.zone.now.to_i
  end
end
