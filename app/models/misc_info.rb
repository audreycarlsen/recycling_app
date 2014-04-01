class MiscInfo
  include Mongoid::Document
  has_one :location

  field :hours,       type: String
  field :cost,        type: String
  field :min_volume,  type: String
  field :max_volume,  type: String
  field :description, type: String
end