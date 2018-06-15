namespace :postal_codes do
  desc "load postal codes from tmp/postal-codes.csv"
  task load: :environment do
    puts "Settle in, this should take about ten minutes..."
    PostalCode.load_csv("#{Rails.root}/tmp/postal-codes.csv")
  end
end
