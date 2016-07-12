class CreatePageobjects < ActiveRecord::Migration
  def change
    create_table :pageobjects do |t|
      t.string :selector
      t.string :href
      t.string :text

      t.timestamps null: false
    end
  end
end
