class AddSubmissionToSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :submission, :string
  end
end
