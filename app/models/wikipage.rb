class Wikipage < ActiveRecord::Base
#  before_create :default_wikipage_public

extend FriendlyId
friendly_id :title

belongs_to :user
has_many :collaborators
has_many :collaborating_users, through: :collaborators, source: :user

  validates :title,
          uniqueness: { case_sensitive: false },
          length: { minimum: 3, maximum: 50 }

# Returns Public Wikis
    scope :public_wikipages, -> { where(private: false) }
# Returns User's Wikis
    scope :personal_wikipages, -> (user) { where(user: user) }
# Returns User's Collaborations
    scope :shared_wikipages, -> (user) { joins(:collaborations).where({ collaborations: { user: user } }) }





end
