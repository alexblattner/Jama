class Level < ApplicationRecord
    belongs_to :game
    has_many :events

    validates :name, presence: true, length: { maximum: 50 }
end
