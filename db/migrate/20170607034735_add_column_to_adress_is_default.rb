class AddColumnToAdressIsDefault < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :is_default, :integer , :default => 0
  end
end
