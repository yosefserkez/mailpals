class CreateHiddenMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :hidden_members do |t|
      t.references :hider, null: false, foreign_key: { to_table: :members }
      t.references :hidden, null: false, foreign_key: { to_table: :members }

      t.timestamps
    end

    add_index :hidden_members, [ :hider_id, :hidden_id ], unique: true
  end
end
