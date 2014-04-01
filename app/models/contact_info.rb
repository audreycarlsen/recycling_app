class ContactInfo
  include Mongoid::Document
  has_one :location

  field :street,  type: String
  field :city,    type: String
  field :zipcode, type: String
  field :phone,   type: String
  field :website, type: String
end