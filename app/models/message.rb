class Message < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  after_create_commit { 
  	MessageBroadcastJob.perform_later(self)
  }
end
