class Friends < ActiveRecord::Migration[5.0]
  def change
    create_table "friends", id: false do |t|
      t.integer "user_a_id", null: false
      t.integer "user_b_id", null: false
    end
  end
end
