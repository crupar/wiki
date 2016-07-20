
class FilterWikis

  def self.call(role)
    case role
    when 'standard'
      Wikipage.where(public: false)
    when 'premium'
      Wikipage.where(collaborator)
    when 'admin'
      Wikipage.all
    end
  end


end
