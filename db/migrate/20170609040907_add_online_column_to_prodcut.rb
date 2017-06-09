class AddOnlineColumnToProdcut < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :online, :boolean, :default => true
  end
end
