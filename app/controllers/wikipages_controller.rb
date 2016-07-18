class WikipagesController < ApplicationController
  include Pundit

rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    wikipages = Wikipage.all
    @wikipages = FilterWikis.call(current_user, wikipages)
  # username = Username.all
  end

  def show
    @wikipage = Wikipage.friendly.find(params[:id])
    @collaborators = @wikipage.collaborating_users

    unless @wikipage.public == false || current_user
      flash[:alert] = "You must be a premium user to view private topics."
      redirect_to root_path
    end
  end

  def new
    @wikipage = Wikipage.new
  end

  def create
     @wikipage = Wikipage.new(wikipage_params)
     @wikipage.user = current_user

     if @wikipage.save
       flash[:notice] = "Entry was saved successfully."
       redirect_to @wikipage, notice: ''
     else
       flash.now[:alert] = "There was an error saving the entry. Please try again."
       render :new
     end
   end


  def edit
    @wikipage = Wikipage.friendly.find(params[:id])
  end

  def update
    @wikipage = Wikipage.friendly.find(params[:id])
    @wikipage.assign_attributes(wikipage_params)
    authorize @wikipage

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
    params.require(:wikipage).permit(:id, :title, :body, :public)
  end

  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end


end
