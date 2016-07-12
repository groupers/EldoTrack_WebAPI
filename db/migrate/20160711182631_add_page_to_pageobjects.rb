class AddPageToPageobjects < ActiveRecord::Migration
  def change
    add_column :pageobjects, :page_id, :integer
  end
end
