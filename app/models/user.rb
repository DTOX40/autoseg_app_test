class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  validate_uniquess_of :auth_token     
  
  def info
	"#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end
end
