class RemoveTypeFromActors < ActiveRecord::Migration
  def change
    remove_column :actors, :type, :string
  end
end
