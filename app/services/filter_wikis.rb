
class FilterWikis

  def self.call(user, wikipages)
    case
    when user.nil?
      wikipages.where(public: true)
    when user.admin? || user.premium?
      wikipages
    when user.standard?
      wikipages.select { |wikipage| wikipage.collaborating_users.include?(user) || wikipage.public? }
    end
  end
end
