class ApiController < ApplicationController
  require 'json'
  require 'date'
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  def index

    @testjsons = Movement.all
    api_response(@testjsons)
  end
# userlinks.select('*').joins(:link).order(:link_id)

  #Need to add restriction in terms of user page acces
  #From actor <- track(mouvement) -> pageobject -> page <- User&Actor_page
  def content_access
    @user = User.find_by_token(params['token'])
    if @user
      case params['type']
        when "tracks"
          api_response(Track.all)
        when "actors"
          api_response(Actor.all)
        when "movements"
          api_response(Movement.all)
        when "pageobjects"
          api_response(Pageobject.all)
        else
          api_response(Page.all)
        end
    end
  end

  def create

    #Actor primary key is token

    #if no hours logged in are given set to zero..
      actor_prms = params['actor']
      # #Must add date conversion if not well formed
      actor = Actor.find_by_token(actor_prms[:token])
      if !actor
        dateOfBirth = Date.strptime(actor_prms[:dofb], '%Y%m%d')
        actor = Actor.new(token: actor_prms[:token], kind: actor_prms[:kind],
        dateOfBirth: dateOfBirth)
        actor.save
      end

      # Must add update conditional
      # page
      page_prms = params['page']
      page = Page.find_by(host: page_prms[:pagehost], path: page_prms[:pagepath], href: page_prms[:pagehref])
      if !page
        page = Page.new(host: page_prms[:pagehost], path: page_prms[:pagepath], href: page_prms[:pagehref])
        page.save
      end
      # actor_page
      actor_page = ActorPage.find_by(actor_id: actor.id, page_id: page.id)
      if !actor_page
        actor_page = ActorPage.new(actor_id: actor.id, page_id: page.id)
        actor_page.save
      end
      # Pageobject
      pageobject_prms = params['object']
      pageobject = Pageobject.find_by(selector: pageobject_prms[:objectselector])
      if !pageobject
        pageobject = Pageobject.new(selector: pageobject_prms[:objectselector],
          href: page_prms[:objecthref], text: pageobject_prms[:objecttext], page_id: page.id)
        pageobject.save
      end
      # Track
      track = Track.new(actor_id: actor.id, pageobject_id: pageobject.id)
      track.save

      # Movement
      params['movements'].each do |item, v|
        movement = Movement.new(x: v[:x], y: v[:y], time: v[:time], track_id: track.id)
        movement.save
      end


     redirect_to '/api'
    # @testjsons = Testjson.new(testjson_params)
    # @testjsons.save

  end

  def track_params
    # params.require(:track).permit(:payload, )
  end
  def testjson_params
    params.require(:testjson).permit(:x,:y,:time)
  end
end
