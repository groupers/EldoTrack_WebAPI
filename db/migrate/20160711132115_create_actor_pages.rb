class CreateActorPages < ActiveRecord::Migration
  def change
    create_table :actor_pages do |t|
      t.integer :actor_id
      t.integer :page_id

      t.timestamps null: false
    end
  end
end
