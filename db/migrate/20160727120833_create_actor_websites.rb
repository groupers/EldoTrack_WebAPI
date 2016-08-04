class CreateActorWebsites < ActiveRecord::Migration
  def change
    create_table :actor_websites do |t|

      t.timestamps null: false
    end
  end
end
