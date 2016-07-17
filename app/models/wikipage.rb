class Wikipage < ActiveRecord::Base
  belongs_to :user
#  before_create :default_wikipage_public



  validates :title,
          uniqueness: { case_sensitive: false },
          length: { minimum: 3, maximum: 50 }





end
