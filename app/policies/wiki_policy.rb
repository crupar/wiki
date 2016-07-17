class WikiPolicy < ApplicationPolicy

  def update?
    user.admin? or user.premium? or current_user?
  end

  def permitted_attributes
    if user.admin? || user.owner_of?(post)
      [:title, :body, :tag_list]
    else
      [:tag_list]
    end
  end


end
