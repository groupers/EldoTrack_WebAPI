class AddProportionsToPageobjects < ActiveRecord::Migration
  def change
    add_column :pageobjects, :width, :decimal
    add_column :pageobjects, :height, :decimal
  end
end
