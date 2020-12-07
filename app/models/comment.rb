class Comment < ApplicationRecord
  belongs_to :device_story
  belongs_to :user
end
