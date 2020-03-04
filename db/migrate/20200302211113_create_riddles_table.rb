class CreateRiddlesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :riddles do |t|
      t.string :title
      t.string :context
      t.string :answer
    end
  end
end
