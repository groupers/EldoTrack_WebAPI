class AddTrackToTestjsons < ActiveRecord::Migration
  def change
    add_column :testjsons, :track, :integer
  end
end
