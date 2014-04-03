class Material
  include Mongoid::Document

  field :name,          type: String
  field :subcategories, type: Array
end