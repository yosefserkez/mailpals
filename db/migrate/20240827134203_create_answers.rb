class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.references :member, null: false, foreign_key: true
      t.references :issue_question, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
