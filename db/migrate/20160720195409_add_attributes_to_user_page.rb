class AddAttributesToUserPage < ActiveRecord::Migration
  def change
    add_column :user_pages, :user_id, :integer
    add_column :user_pages, :page_id, :integer
  end
end
