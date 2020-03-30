class Level < ApplicationRecord
    belongs_to :game

    validates :name, presence: true, length: { maximum: 50 }
end
