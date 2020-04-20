class Level < ApplicationRecord
    has_one_attached :level_image
    belongs_to :game
    has_many :events
    validates :name, presence: true, length: { maximum: 50 }
    has_one_attached :level_image
end
