class DropPostsTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :posts
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
