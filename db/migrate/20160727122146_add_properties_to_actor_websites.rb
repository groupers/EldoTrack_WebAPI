class AddPropertiesToActorWebsites < ActiveRecord::Migration
  def change
    add_column :actor_websites, :actor_id, :integer
    add_column :actor_websites, :website_id, :integer
  end
end
