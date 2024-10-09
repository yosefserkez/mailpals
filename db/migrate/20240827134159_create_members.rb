class CreateMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :members do |t|
      t.string :display_name
      t.references :user, null: false, foreign_key: true
      t.references :club, null: false, foreign_key: true
      t.string :role
      t.datetime :invitation_sent_at
      t.datetime :activated_at

      t.timestamps
    end
  end
end
