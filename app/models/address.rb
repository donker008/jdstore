class Address < ApplicationRecord
  validates :name , presence:true
  validates :address, presence:true
  validates :contact_info, presence:true
end
