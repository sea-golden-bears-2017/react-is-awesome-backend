class Friends < ActiveRecord::Migration[5.0]
  def change
    create_table "friends", id: false do |t|
      t.index "user_a_id", null: false
      t.index "user_b_id", null: false
    end
  end
end
