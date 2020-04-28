class Hero < ApplicationRecord
    has_one_attached :hero_image

    def attachment_url
        if self.hero_image.attached?
          Rails.application.routes.url_helpers.rails_blob_path(self.hero_image, only_path:true)
        else
          nil
        end
    end
end
