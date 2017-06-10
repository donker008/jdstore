class AddProductIdToHomeas < ActiveRecord::Migration[5.0]
  def change
    add_column :homeads, :product_id, :integer
  end
end
