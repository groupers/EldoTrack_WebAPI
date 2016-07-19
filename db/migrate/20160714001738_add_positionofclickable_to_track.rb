class AddPositionofclickableToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :track_x, :decimal
    add_column :tracks, :track_y, :decimal
  end
end
