class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :residence
      t.integer :credit
      t.integer :aether
      t.integer :item
      t.integer :stealth
      t.integer :defense
      t.integer :user_id

      t.timestamps
    end
    add_index :buildings, [:user_id]
  end
end
