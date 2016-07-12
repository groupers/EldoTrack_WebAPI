class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :host
      t.string :path
      t.string :href

      t.timestamps null: false
    end
  end
end
