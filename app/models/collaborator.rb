class Collaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :wikipage
end
