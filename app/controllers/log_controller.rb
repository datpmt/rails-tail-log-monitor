class LogController < ::ApplicationController
  layout 'log'
  def index
    # LogMonitorService.start_monitoring
  end
  def show; end
end