# [RailsUse](https://github.com/shotay79/rails-use)

## Installation
```rb
gem 'rails-use'
```

## Usage
### railsroutes2aspida
Please create a file named `config/initializers/railsroutes2aspida.rb`` and specify the path to aspida/api as shown:
```ruby
Rails::Use::Railsroutes2aspida.configure do |config|
  config.routes_file = '/your/path/to/aspida/api'
end
```

Afterwards, executing `bundle exec railsroutes2aspida` will generate the API definition files.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/api-generator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
