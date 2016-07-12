class AddFinalToTestjsons < ActiveRecord::Migration
  def change
    add_column :testjsons, :final, :boolean
  end
end
