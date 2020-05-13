class DoorSerializer < ActiveModel::Serializers
  attributes :id, :name, :next_levels, :description, :image, :result, :requirement
end
