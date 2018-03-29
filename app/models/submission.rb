class Submission < ApplicationRecord
  mount_uploader :submission, SubmissionUploader
  belongs_to :challenge
end
