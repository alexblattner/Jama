class Game < ApplicationRecord
    has_many :levels
    has_many :gamestates

    validates :game_name, presence: true, length: { maximum: 50 }
end
