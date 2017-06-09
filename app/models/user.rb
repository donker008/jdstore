class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 has_many :orders
 has_many :favorites
 has_many :reviews
 mount_uploader :avatar, ImageUploader

def user_display_name
    if !self.nick_name.blank?
      self.nick_name
    elsif !self.name.blank?
      self.name
    else
      self.email
    end
end

end
