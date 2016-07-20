class WikipagesController < ApplicationController
  include Pundit

rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @wikipages = FilterWikis.call(current_user.role)
    #@wikipages, @alphaParams = Wikipage.alpha_paginate(params[:letter]){|wikipage| wikipage.title}
  end

  def show
    @wikipage = Wikipage.friendly.find(params[:id])
    @collaborator = @wikipage.collaborator_users
  end

  def new
    @wikipage = Wikipage.new
  end

  def create
     @wikipage = current_user.wikipages.new(wikipage_params)

     if @wikipage.save
       flash[:notice] = "Entry was saved successfully."
       redirect_to @wikipage
     else
       flash.now[:alert] = "There was an error saving the entry. Please try again."
       render :new
     end
   end


  def edit
    @wikipage = Wikipage.friendly.find(params[:id])
    @users = User.where.not(id: current_user.id)
  #  @users, @alphaParams = User.all.alpha_paginate(params[:letter]){|user| user.username}

  end

  def update
    @wikipage = Wikipage.friendly.find(params[:id])
    @wikipage.assign_attributes(wikipage_params)

    if @wikipage.save
      flash[:notice] = "Entry was updated successfully."
      redirect_to [@wikipage]
    else
      flash.now[:alert] = "There was an error saving the entry. Please try again."
      render :edit
    end
  end

  def destroy
    @wikipage = Wikipage.friendly.find(params[:id])
    authorize @wikipage

    if @wikipage.destroy
      flash[:notice] = "\"#{@wikipage.title}\" was deleted successfully."
      redirect_to wikipages_path
    else
      flash.now[:alert] = "There was an error deleting the wiki entry."
      render :show
    end
  end

  private

  def wikipage_params
    params.require(:wikipage).permit(:id, :title, :body, :public, user_ids: [])
  end

  def user_params
    params.require(:user).permit(:id, :role, :username)
  end

  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end




end
