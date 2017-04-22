class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, index: { unique: true}
      t.string :password_hash
      t.boolean :is_admin?
      t.timestamps
    end
  end
end
