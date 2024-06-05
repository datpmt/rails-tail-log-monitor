# lib/rails-tail-log-monitor.rb
require 'rails-tail-log-monitor/engine'
require 'rails-tail-log-monitor/version'

module LogMonitor
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.start
    LogMonitorService.new
  end

  class Configuration
    attr_accessor :action_cable_url

    def initialize
      @action_cable_url = 'ws://default.url/cable'
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

    def initialize
      # $monitoring_thread ||= Thread.new { monitor_log }
      test_method
    end

    def self.start_monitoring
      puts 'start_monitoring xxxx'
      Thread.new { monitor_log }
    end

    def self.monitor_log
      log_file = Rails.root.join('log', "#{Rails.env}.log")
      last_position = File.size(log_file)

      begin
        loop do
          new_log_entries = File.open(log_file, 'r') do |file|
            file.seek(last_position)
            file.read
          end.split("\n")
          ActionCable.server.broadcast('room_channel', { log_entries: new_log_entries.map { |log| ansi_to_html(log) } }) if new_log_entries.present?

          last_position = File.size(log_file)
        end
      rescue StandardError => e
        Rails.logger.error "Error in LogMonitorService: #{e.message}"
      end
    end

    def test_method
      log_file = Rails.root.join('log', "#{Rails.env}.log")
      puts "log_file: #{log_file} \n" * 10
    end

    def self.ansi_to_html(ansi_text)
      html_text = ansi_text.dup
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
