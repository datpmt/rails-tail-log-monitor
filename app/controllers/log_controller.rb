# frozen_string_literal: true

require 'rails-tail-log-monitor'
class LogController < ::ApplicationController
  layout 'log'
  def index
    LogMonitor::LogMonitorService.start_monitoring
  end
end
