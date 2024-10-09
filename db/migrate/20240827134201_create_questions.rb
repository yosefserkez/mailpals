class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.text :prompt
      t.string :category
      t.string :asked_by
      t.integer :priority

      t.timestamps
    end
  end
end
