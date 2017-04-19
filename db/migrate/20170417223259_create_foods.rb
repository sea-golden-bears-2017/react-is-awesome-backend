class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.string :unit, null: false
      t.timestamps
    end
  end
end
