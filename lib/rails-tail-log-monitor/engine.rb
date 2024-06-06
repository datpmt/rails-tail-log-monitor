# lib/rails-tail-log-monitor/engine.rb
module LogMonitor
  class Engine < ::Rails::Engine
    isolate_namespace LogMonitor

    initializer 'log_monitor.assets.precompile' do |app|
      app.config.assets.precompile += %w[example.js]
    end

    initializer 'log_monitor.routes' do |app|
      app.routes.append do
        get '/log', to: 'log#index'
      end
    end
  end
end
