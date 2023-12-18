namespace :railsserializer2types do
  desc 'Generate aspida files from Rails routes'
  task execute: :environment do
    Rails::Use::Railsserializer2types.execute
  end
end
