# Rails Tail Log Monitor

The rails-tail-log-monitor gem simplifies the process of monitoring server logs by displaying the tail of the log file directly in the terminal window alongside the standard Rails server output. With rails-tail-log-monitor, developers can effortlessly keep track of the most recent log entries without the need for manual log file inspection.

![demo](demo.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-tail-log-monitor', '~> 1.0.0'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rails-tail-log-monitor

## Usage
Make sure your `package.json` has `actioncable`
```json
{
  ...,
  "@rails/actioncable": "^6.0.0"
}
```
Update `config/cable.yml`
```yaml
development:
  adapter: redis
  url: <%= "redis://localhost:6379/#{ENV.fetch('REDIS_PORT')}" %>
  channel_prefix: your_app_development
```
Update `routes.rb`
```ruby
# config/routes.rb
Rails.application.routes.draw do
  ...
  # example for usage same Sidekiq
  authenticate :administrator do
    mount Sidekiq::Web => '/sidekiq'
    mount LogMonitor::Engine => '/log'
  end
end
```
Custom setting `config/initializers/rails_tail_log_monitor.rb`
```ruby
LogMonitor.configure do |config|
  config.action_cable_url = "ws://localhost:3000/cable"
  config.keep_alive_time = 60 # default = 30
end
```

After installation and configuration, start your Rails application, open `http://localhost:3000/log` URL, and make a few requests.


## Contributors

- [datpmt](https://github.com/datpmt)

I welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b your-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin your-feature`).
5.  Create a new pull request.

## License
The gem is available as open source under the terms of the [MIT License](LICENSE).
