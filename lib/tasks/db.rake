namespace :db do
  desc "load initial database information for production"
  task init: :environment do
    require "#{Rails.root}/db/init.rb"
  end
  
  desc "reset database, reloading init data"
  task resets: ['db:drop', 'db:create', 'db:schema:load', 'db:init']
end
