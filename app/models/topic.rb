class Topic < ApplicationRecord
    validates :name, presence: true, length: { maximum: 50 }
    # validates :topictype, presence: true
    has_many :messages
    TYPE_LIST = ["Rate the game", "Game strategy", "Questions about the Game"]
end
