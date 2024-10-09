class CreateIssueQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :issue_questions do |t|
      t.references :issue, null: false, foreign_key: true
      t.string :section
      t.string :title
      t.text :prompt
      t.text :kind
      t.json :options
      t.string :category
      t.string :asked_by
      t.integer :priority

      t.timestamps
    end
  end
end
