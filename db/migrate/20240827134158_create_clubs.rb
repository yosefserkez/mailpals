class CreateClubs < ActiveRecord::Migration[7.2]
  def change
    create_table :clubs do |t|
      t.string :title
      t.text :description
      t.boolean :active
      t.integer :default_number_questions
      t.integer :delivery_time
      t.integer :delivery_frequency
      t.integer :delivery_day
      t.string :invite_code
      t.json :sections

      t.timestamps
    end
  end
end
