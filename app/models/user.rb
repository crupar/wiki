class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  before_save { self.role ||= :standard }
  enum role: [:standard, :premium, :admin]


  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  has_many :charges
  has_many :subscriptions
  has_many :wikipages
  has_many :collaborators
  has_many :wikipage_collaborators, through: :collaborators, source: :wikipage


attr_accessor :login

def self.find_for_database_authentication(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:login)
    where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  elsif conditions.has_key?(:username) || conditions.has_key?(:email)
    where(conditions.to_h).first
  end
end

end
