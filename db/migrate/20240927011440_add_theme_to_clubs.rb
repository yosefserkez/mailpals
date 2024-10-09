class AddThemeToClubs < ActiveRecord::Migration[7.2]
  def change
    add_column :clubs, :theme, :string, default: "base"
  end
end
