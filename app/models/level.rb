class Level < ApplicationRecord
    has_one_attached :level_image
    belongs_to :game
    has_many :events
end
