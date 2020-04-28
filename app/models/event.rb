class Event < ApplicationRecord
    belongs_to :game
    validates :name, presence: true, length: { maximum: 50 }
    has_one_attached :event_image

end
