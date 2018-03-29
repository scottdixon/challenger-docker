class AddTestToChallenges < ActiveRecord::Migration[5.1]
  def change
    add_column :challenges, :test, :string
  end
end
