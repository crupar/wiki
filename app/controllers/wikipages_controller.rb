class WikipagesController < ApplicationController
  include Pundit

rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

after_action :verify_authorized, only: [:destroy]

  def index
    @wikipages = User.friendly.select("role")
  #  authorize @wikipages

  end

  def show
    @wikipage = Wikipage.friendly.find(params[:id])
    authorize @wikipage
    unless @wikipage.public || current_user
      flash[:alert] = "You must be a premium user to view private topics."
      redirect_to @wikipage
    end
  end

  def new
    @wikipage = Wikipage.new
  end

  def create
    authorize @wikipage
     @wikipage = Wikipage.new(wikipage_params)
     @wikipage.user = current_user

     if @wikipage.save
       flash[:notice] = "Entry was saved successfully."
       redirect_to [@wikipage]
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
    authorize @wikipage

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
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the wiki entry."
      render :show
    end
  end

  private

  def wikipage_params
    params.require(:wikipage).permit(:id, :title, :body, :public)
  end

  def user_params
    params.require(:user).permit(:id, :role)
  end


  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end


end
