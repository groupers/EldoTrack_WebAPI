class AddKindToActors < ActiveRecord::Migration
  def change
    add_column :actors, :kind, :string
  end
end
