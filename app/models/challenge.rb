class Challenge < ApplicationRecord
  mount_uploader :challenge, ChallengeUploader
  mount_uploader :test, TestUploader
end
