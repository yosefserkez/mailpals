class ChangeRoleToIntegerInMembers < ActiveRecord::Migration[7.2]
  def up
    # First, add a temporary column
    add_column :members, :role_int, :integer

    # Migrate the data
    execute <<-SQL
      UPDATE members
      SET role_int = CASE
        WHEN role = 'owner' THEN 2
        WHEN role = 'admin' THEN 1
        WHEN role = 'member' THEN 0
        ELSE 0
      END
    SQL

    # Remove the old column
    remove_column :members, :role

    # Rename the new column
    rename_column :members, :role_int, :role

    # Add a default value and not null constraint
    change_column_default :members, :role, 0
    change_column_null :members, :role, false
  end

  def down
    change_column :members, :role, :string
    change_column_default :members, :role, nil
    change_column_null :members, :role, true

    # Convert back to strings
    execute <<-SQL
      UPDATE members
      SET role = CASE
        WHEN role = 2 THEN 'owner'
        WHEN role = 1 THEN 'admin'
        WHEN role = 0 THEN 'member'
        ELSE 'member'
      END
    SQL
  end
end
