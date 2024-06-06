# lib/rails-tail-log-monitor.rb

require 'rails-tail-log-monitor/engine'

module LogMonitor
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    DEFAULT_ACTION_CABLE_URL = 'ws://localhost:3000/cable'.freeze
    DEFAULT_KEEP_ALIVE_TIME = 30

    class << self
      def action_cable_url
        configuration.action_cable_url
      end

      def keep_alive_time
        configuration.keep_alive_time
      end
    end

    attr_accessor :action_cable_url, :keep_alive_time

    def initialize
      @action_cable_url = DEFAULT_ACTION_CABLE_URL
      @keep_alive_time = DEFAULT_KEEP_ALIVE_TIME
    end

    def keep_alive_time=(time)
      @keep_alive_time = [time.to_i, DEFAULT_KEEP_ALIVE_TIME].max
    end
  end

  class Railtie < Rails::Railtie
    config.after_initialize do
      ActionCable.server.config.logger = Logger.new(nil)
      ActionCable.server.config.url = LogMonitor.configuration.action_cable_url
    end
  end

  class LogMonitorService
    ANSI_TO_HTML = {
      '30' => 'black',
      '31' => 'red',
      '32' => 'green',
      '33' => 'yellow',
      '34' => 'blue',
      '35' => 'magenta',
      '36' => 'cyan',
      '37' => 'white',
      '90' => 'darkgrey',
      '91' => 'lightred',
      '92' => 'lightgreen',
      '93' => 'lightyellow',
      '94' => 'lightblue',
      '95' => 'lightmagenta',
      '96' => 'lightcyan',
      '97' => 'lightgrey'
    }.freeze

    def self.start_monitoring
      $monitoring_keep_alive = Time.zone.now.to_i
      $monitoring_thread ||= Thread.new { monitor_log }
    end

    def self.stop_monitoring
      $monitoring_thread&.kill
      $monitoring_thread&.join
      $monitoring_thread = nil
    end

    def self.monitor_log
      log_file = Rails.root.join('log', "#{Rails.env}.log")
      last_position = File.size(log_file)

      begin
        loop do
          sleep 0.3
          if Time.zone.now.to_i - $monitoring_keep_alive > LogMonitor.configuration.keep_alive_time
            stop_monitoring
            break
          else
            new_log_entries = File.open(log_file, 'r') do |file|
              file.seek(last_position)
              file.read
            end.split("\n", -1)
            if new_log_entries.present?
              new_log_entries = new_log_entries[0..-2] if new_log_entries.last.empty?
              ActionCable.server.broadcast(
                'log_channel', { log_entries: new_log_entries.map { |log| ansi_to_html(log) } }
              )
            end

            last_position = File.size(log_file)
          end
        end
      rescue StandardError => e
        Rails.logger.error "Error in LogMonitorService: #{e.message}"
      end
    end

    def self.ansi_to_html(log)
      return '<br>' if log.blank?

      html_text = log.dup
      html_text = html_text.gsub('<', '&lt;').gsub('>', '&gt;')
      ANSI_TO_HTML.each_key do |code|
        html_text.gsub!(/\e\[#{code}m/, "<span style='color: #{ANSI_TO_HTML[code]};'>")
      end
      html_text.gsub!(/\e\[0m/, '</span>')
      html_text.gsub!(/\e\[1m/, "<span style='font-weight: bold;'>")
      html_text
    end
  end
end
