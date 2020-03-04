class CreateRiddlebooksTable < ActiveRecord::Migration[5.2]
  def change
    create_table :riddlebooks do |t|
      t.integer :user_id
      t.integer :riddle_id
    end
  end
end
