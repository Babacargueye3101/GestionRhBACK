class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :shops, dependent: :destroy
  belongs_to :compagny

  enum role: { admin: 'admin', manager: 'manager', employee: 'employee' }

  after_initialize :set_default_role, if: :new_record?







  def generate_jwt
    JWT.encode({ id: id, exp: 24.hours.from_now.to_i }, ENV['SECRET_KEY_BASE'])
  end


  private

  def set_default_role
    self.role ||= 'employee'
  end

end
