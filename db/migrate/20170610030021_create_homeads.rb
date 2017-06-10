class CreateHomeads < ActiveRecord::Migration[5.0]
  def change
    create_table :homeads do |t|
      t.string :name
      t.string :image
      t.integer :priority, :default => 0
      t.boolean :online, :default => false
      t.timestamps
    end
  end
end
