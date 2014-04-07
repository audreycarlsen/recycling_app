class Location
  include Mongoid::Document

  field :name,          type: String
  field :latitude,      type: String
  field :longitude,     type: String
  field :materials,     type: Array
  field :residents,     type: Boolean
  field :business,      type: Boolean
  field :pick_up,       type: Boolean
  field :drop_off,      type: Boolean
  field :mail_in,       type: Boolean
  field :location_type, type: String
  field :street,        type: String
  field :city,          type: String
  field :zipcode,       type: String
  field :phone,         type: String
  field :website,       type: String
  field :hours,         type: String
  field :cost,          type: String
  field :min_volume,    type: String
  field :max_volume,    type: String
  field :description,   type: String
end