namespace :db do
  desc "load initial database information for production"
  task init: :environment do
    require "#{Rails.root}/db/init.rb"
  end
end
