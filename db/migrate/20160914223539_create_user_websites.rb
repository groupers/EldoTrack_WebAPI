class CreateUserWebsites < ActiveRecord::Migration
  def change
    create_table :user_websites do |t|
      t.integer :user_id
      t.integer :website_id

      t.timestamps null: false
    end
  end
end
