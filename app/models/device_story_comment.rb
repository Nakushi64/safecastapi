class DeviceStoryComment < ApplicationRecord
  belongs_to :device_story
  belongs_to :user
end
