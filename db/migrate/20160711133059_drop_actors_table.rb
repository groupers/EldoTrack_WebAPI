class DropActorsTable < ActiveRecord::Migration
  def up
    drop_table :actors
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
