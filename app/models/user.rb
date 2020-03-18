class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers,   inverse_of: "author"
  has_many :questions, inverse_of: "author"

  def author?(resource)
    self == resource.author
  end
end
