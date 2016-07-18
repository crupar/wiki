class CollaboratorsController < ApplicationController
  def create
    @wiki = Wiki.find(params[:wiki_id])
    user = User.find(params[:user_id])
    collaborator = Collaborator.new(user: user, wiki: @wiki)
    if collaborator.save
      redirect_to wiki_path(@wiki), notice: 'Collaborator Added'
    else
      flash[:alert] = 'Failed to add collaborator'
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    user = User.find(params[:user_id])
    collaborator = Collaborator.find_by(user_id: user.id, wiki_id: @wiki.id)
    if collaborator.destroy
      redirect_to wiki_path(@wiki), notice: 'Collaborator removed'
    else
      flash[:alert] = 'Failed to remove collaborator'
      render :edit
    end
  end
end
