namespace :postal do
  def load_postal_codes
    PostalCode.load_csv("#{Rails.root}/tmp/postal-codes.csv")
    puts "Postal Codes added: #{PostalCode.count}"
  end
  
  def load_metros
    Metro.load_txt("#{Rails.root}/tmp/msa.txt")
    puts "Metros added: #{Metro.count}"
  end
  
  desc "load postal codes from tmp/postal-codes.csv"
  task codes: :environment do
    load_postal_codes
  end
  
  desc "load metro areas from tmp/msa.txt"
  task metros: :environment do
    load_metros
  end
  
  desc "load both postal codes and metros from tmp directory"
  task load: :environment do
    load_postal_codes
    load_metros
  end
end
