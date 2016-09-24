class AddPageIdToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :page_id, :integer
  end
end
