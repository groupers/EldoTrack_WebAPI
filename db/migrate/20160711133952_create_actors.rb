class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :type
      t.string :token
      t.date :dateOfBirth
      t.decimal :hoursLoggedIn
      t.decimal :frequency
      t.decimal :experience
      t.decimal :percentile

      t.timestamps null: false
    end
  end
end
