class CreateTestjsons < ActiveRecord::Migration
  def change
    create_table :testjsons do |t|
      t.string :x
      t.string :y
      t.string :time

      t.timestamps null: false
    end
  end
end
