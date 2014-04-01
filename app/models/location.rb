class Location
  include Mongoid::Document
  embeds_one :contact_info
  embeds_one :misc_info

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
end