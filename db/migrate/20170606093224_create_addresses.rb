class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :address
      t.string :contact_info
      t.timestamps
    end
  end
end
