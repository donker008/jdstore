class AddOtherColumsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nick_name, :string , :default => "用户"
    add_column :users, :sex, :integer , :default => "0"
    add_column :users, :birthday, :date
    add_column :users, :phone, :string
    add_column :users, :address, :string
  end
end
