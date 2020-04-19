class Game < ApplicationRecord
    has_many :levels
    has_many :events
    has_many :gamestates
    has_one_attached :game_image

    validates :game_name, presence: true, length: { maximum: 50 }
end
