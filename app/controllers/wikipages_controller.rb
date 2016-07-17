class WikipagesController < ApplicationController

  def index
    @wikipages = Wikipage.all
  end

  def show
    @wikipage = Wikipage.find(params[:id])
  end

  def new
    @wikipage = Wikipage.new
  end

  def create
     @wikipage = Wikipage.new(wikipage_params)
     @wikipage.user_id = current_user_id

     if @wikipage.save
       flash[:notice] = "Entry was saved successfully."
       redirect_to [@wikipage]
     else
       flash.now[:alert] = "There was an error saving the entry. Please try again."
       render :new
     end
   end

  def edit
    @wikipage = Wikipage.find(params[:id])
  end

  def update
    @wikipage = Wikipage.find(params[:id])
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
    @wikipage = Wikipage.find(params[:id])

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

  def user_params
    params.require(:user).permit(:id, :role)
  end


end