class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username

  has_many :wikipages, dependent: :delete_all


  enum role: [:standard, :premium, :admin]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
#  has_secure_password
  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

    validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

attr_accessor :login


scope :public_wikipages, -> { where(private: false) }
# Returns User's Wikis
scope :personal_wikipages, -> (user)  { where(user: user) }
# Returns User's Collaborations
scope :shared_wikipages, -> (user) { joins(:collaborations).where({ collaborations: { user: user } }) }


def self.find_for_database_authentication(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:login)
    where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  elsif conditions.has_key?(:username) || conditions.has_key?(:email)
    where(conditions.to_h).first
  end
end

def standard?
  role == 'standard'
end

def premium?
  role == 'premium'
end

def admin?
  role == 'admin'
end

#check:
def publicize_wikipagess_if_standard
  if standard?
    wikipages.each do |wikipage|
      wikipage.public = true
      wikipage.save
    end
  end
end
#
end
