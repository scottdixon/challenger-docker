class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.references :challenge, foreign_key: true

      t.timestamps
    end
  end
end
