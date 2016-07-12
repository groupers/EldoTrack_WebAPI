class AddColumnsToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :actor_id, :integer
    add_column :tracks, :pageobject_id, :integer
    add_column :tracks, :mouvement_id, :integer
  end
end
