class AddTrackTimeToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :track_time, :decimal
  end
end
