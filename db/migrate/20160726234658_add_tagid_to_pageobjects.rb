class AddTagidToPageobjects < ActiveRecord::Migration
  def change
    add_column :pageobjects, :tagid, :string
  end
end
