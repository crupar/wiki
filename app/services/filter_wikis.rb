
class FilterWikis

  def self.call(user, wikipages)
    case user
    when 'standard'
      Wikipages.where(public: true)
    when 'premium'
      wikipages.all
    when 'admin'
      wikipages.all
    end
  end
end
