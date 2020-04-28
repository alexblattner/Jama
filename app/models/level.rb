class Level < ApplicationRecord
    has_one_attached :level_image
    belongs_to :game
    has_many :events
    validates :name, presence: true, length: { maximum: 50 }
    has_one_attached :level_image

    def attachment_url
        if self.level_image.attached?
          Rails.application.routes.url_helpers.rails_blob_path(self.level_image, only_path:true)
        else
          nil
        end
    end
end
