class Event < ApplicationRecord
    belongs_to :game
    validates :name, presence: true, length: { maximum: 50 }
    has_one_attached :event_image
    def attachment_url
        if self.event_image.attached?
          Rails.application.routes.url_helpers.rails_blob_path(self.event_image, only_path:true)
        else
          nil
        end
    end
end
