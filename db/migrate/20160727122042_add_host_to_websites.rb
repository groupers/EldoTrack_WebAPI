class AddHostToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :host, :string
  end
end
