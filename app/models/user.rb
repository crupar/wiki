class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
#  has_secure_password

  has_many :wikipages

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

    validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

attr_accessor :login

def self.find_for_database_authentication(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:login)
    where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  elsif conditions.has_key?(:username) || conditions.has_key?(:email)
    where(conditions.to_h).first
  end
end

def standard?
  self.role == 'standard'
end

def premium?
  self.role == 'premium'
end

def admin?
  self.role == 'admin'
end

end