class CreateIssues < ActiveRecord::Migration[7.2]
  def change
    create_table :issues do |t|
      t.references :club, null: false, foreign_key: true
      t.string :title
      t.datetime :open_at
      t.datetime :deliver_at
      t.datetime :sent_at
      t.json :sections

      t.timestamps
    end
  end
end
