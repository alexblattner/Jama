class DoorSerializer < ActiveModel::Serializer
  attributes :id, :name, :next_levels, :description, :image, :result, :requirement
end
