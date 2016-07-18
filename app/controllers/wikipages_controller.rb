class WikipagesController < ApplicationController
  include Pundit

rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
#    @wikipages = User.friendly.select("role")

  #  authorize @wikipages

  @wikipages = policy_scope(Wikipage)


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
    authorize @wikipage

  end

  def create
     @wikipage = Wikipage.new(wikipage_params)
     authorize @wikipage
     @wikipage.user = current_user

     @wikipage.assign_attributes(wikipage_params)

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

    if @wikipage.delete
      redirect_to action: :index

      flash[:notice] = "\"#{@wikipage.title}\" was deleted successfully."
      @wikipage.assign_attributes(wikipage_params)
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
