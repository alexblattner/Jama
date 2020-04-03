class Event < ApplicationRecord
    belongs_to :level
    belongs_to :game
end
