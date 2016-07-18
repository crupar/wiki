
class FilterWikis

  def self.call(role)
    case role
    when 'standard'
      Wikipage.where(public: false)
    when 'premium', 'admin'
      Wikipage.all
    end
  end

end
