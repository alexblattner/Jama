class Level < ApplicationRecord
    belongs_to :game
    has_many :events
end
