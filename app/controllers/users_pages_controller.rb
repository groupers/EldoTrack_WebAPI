class UsersPagesController < ApplicationController
  before_action :authenticate_user!
  def index

    @pages = Page.joins(:user_pages).merge(UserPage.where(user_id: current_user.id))
    @page_href = "https://localhost:3000/"

  end

  def show
  end

  def create
  end

  def observe
    @pages = Page.joins(:user_pages).merge(UserPage.where(user_id: current_user.id))
    @page = params[:userpage]
    if @page
      @page_href = Page.find(@page).href
    else
      @page_href = "https://localhost:3000/"
    end
    # @clickables =
    render action: :index
  end

end
