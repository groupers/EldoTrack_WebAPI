class UsersPagesController < ApplicationController
  before_action :authenticate_user!
  def index

    @pages = Page.joins(:user_pages).merge(UserPage.where(user_id: current_user.id))
    #Must be replace to local
    @page_href = "#{Rails.root}"

  end

  def show
  end

  def new
    @userPage = UserPage.new
  end
  def create
    up = params[:user_pages]
    p = Page.find_by(host: up[:host])
    @page =  p ? p : Page.new(host: up[:host])
    @page.save
    if current_user
      @userPage = UserPage.create(user_id: current_user.id, page_id: @page.id)
      respond_to do |format|
        format.js
        # format.html {redirect_to iup_path}
      end
    end

  end

  def observe
    @pages = Page.joins(:user_pages).merge(UserPage.where(user_id: current_user.id))
    @page = params[:userpage]
    if @page
      @page_href = Page.find(@page).href
    else
      @page_href = "#{Rails.root}"
    end
    # @clickables =
    render action: :index
  end

end
