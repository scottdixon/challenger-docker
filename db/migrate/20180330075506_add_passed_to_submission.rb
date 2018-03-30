class AddPassedToSubmission < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :passed, :boolean
  end
end
