class Topic < ApplicationRecord
    validates :name, presence: true, length: { maximum: 50 }
    # validates :topictype, presence: true
    has_many :messages
    has_one_attached :topic_image
    TYPE_LIST = ["Rate the game", "Game strategy", "Questions about the Game"]
end
