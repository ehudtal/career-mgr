require 'geo_distance'

class PostalCode < ApplicationRecord
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :latitude, presence: true, numericality: {greater_than: 18.0, less_than: 72.0}
  validates :longitude, presence: true, numericality: {greater_than: -160.0, less_than: -50.0}

  class << self
    def distance origin_zip, destination_zip
      origin = find_by code: origin_zip
      destination = find_by code: destination_zip
      
      GeoDistance.haversine(origin.coordinates, destination.coordinates)
    end
  end
  
  def coordinates
    [lat, lon]
  end
  
  def coordinates= new_coordinates
    self.lat = new_coordinates[0]
    self.lon = new_coordinates[1]
  end
  
  def lat
    latitude
  end
  
  def lat= new_latitude
    self.latitude = new_latitude
  end
  
  def lon
    longitude
  end
  
  def lon= new_longitude
    self.longitude = new_longitude
  end
end
