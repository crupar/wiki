class Wikipage < ActiveRecord::Base
#  before_create :default_wikipage_public

extend FriendlyId
friendly_id :title

belongs_to :user
has_many :collaborators
has_many :users, through: :collaborators

validates :title,
          uniqueness: { case_sensitive: false },
          length: { minimum: 3, maximum: 50 }




end
