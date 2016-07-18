class WikipagePolicy < ApplicationPolicy
  class Scope
      attr_reader :user, :scope # :wiki,

      def initialize(user, scope) # wiki,
        @user = user
        @scope = scope
      end

      def resolve
         wikis = []
         if user.role == 'admin'
           wikis = scope.all # if the user is an admin, show them all the wikis
         elsif user.role == 'premium'
           all_wikis = scope.all
           all_wikis.each do |wiki|
             if wiki && wiki.user == user
               wikis << wiki
             end
           end
         else # this is the  standard user
           all_wikis = scope.all
           wikis = scope.all
         end
         wikis # return the wikis array we've built up
       end
     end



end
