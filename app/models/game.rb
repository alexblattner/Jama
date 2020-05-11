class Game < ApplicationRecord
    has_many :levels
    has_many :events
    has_many :gamestates
    has_many :doors
    has_one_attached :game_image
    validates :game_name, presence: true, length: { maximum: 50 }
    def self.search(search)
      if search
        where('game_name LIKE ? OR description LIKE ?',"%#{search}%","%#{search}%")
      else
        where("1=1")
      end
    end
end
