
class FilterWikis

  def self.call(role)
    case role
    when 'standard'
      Wikipage.where(public: false)
    when 'premium'
      Wikipage.where(Collaborator.exists?(:username))
    when 'admin'
      Wikipage.all
    end
  end


end
