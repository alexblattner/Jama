class Game < ApplicationRecord
    has_many :levels
    has_many :gamestates
end
