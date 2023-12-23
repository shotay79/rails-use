# [RailsUse](https://github.com/shotay79/rails-use)

## Installation
```rb
gem 'rails-use'
```

## Usage
### railsroutes2aspida
Please create a file named `config/initializers/railsroutes2aspida.rb`` and specify the path to aspida/api as shown:
```ruby
Rails::Use.configure do |config|
  config.aspida_output_dir = '/your/path/to/aspida/api'
  config.schema_output_dir = '/your/path/to/types'
end

```

Afterwards, executing `bundle exec railsroutes2aspida` will generate the API definition files.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/api-generator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
