class RemoveMouvementIdFromTrack < ActiveRecord::Migration
  def change
    remove_column :tracks, :mouvement_id, :integer
  end
end
