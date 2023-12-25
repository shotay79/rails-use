namespace :railsserializer2schema do
  desc 'Generate aspida files from Rails routes'
  task execute: :environment do
    RailsUse::Railsserializer2schema.execute
  end
end
