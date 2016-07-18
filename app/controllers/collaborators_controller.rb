class CollaboratorsController < ApplicationController


  # username = Username.all


  def create
    @wikipage = Wikipage.find(params[:wikipage_id])
    user = User.find(params[:user_id])
    collaborator = Collaborator.new(user: user, wikipage: @wikipage)
    if collaborator.save
      redirect_to wikipage_path(@wikipage), notice: 'Collaborator Added'
    else
      flash[:alert] = 'Failed to add collaborator'
      render :edit
    end
  end


  def destroy
    @wikipage = Wikipage.find(params[:wikipage_id])
    user = User.find(params[:user_id])
    collaborator = Collaborator.find_by(user_id: user.id, wikipage_id: @wikipage.id)
    if collaborator.destroy
      redirect_to wikipage_path(@wikipage), notice: 'Collaborator removed'
    else
      flash[:alert] = 'Failed to remove collaborator'
      render :edit
    end
  end


end
