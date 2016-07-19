class ApiController < ApplicationController
  require 'json'
  require 'date'
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  def index
  page_specific = Pageobject.where(page_id: 1)
  @pageobjects_x_tracks = page_specific.all.select('*').joins(:tracks)
  @movements = Movement.where(track_id: @pageobjects_x_tracks[0][:id])

    api_response(@movements)
  end

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
          if params['which']
            page = Page.find_by(id: params['which'])
            objects = Pageobject.where(page_id: page.id)
            @pageobjects_x_tracks = objects.all.select('*').joins(:tracks, :movements)
            api_response(@pageobjects_x_tracks)
          else
            api_response(Movement.all)
          end
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
       actor.hoursLoggedIn = 0 if !actor.hoursLoggedIn
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
      pageobject = Pageobject.find_by(selector: pageobject_prms[:objectselector], href: pageobject_prms[:objecthref], text: pageobject_prms[:objecttext], page_id: page.id)
      if !pageobject
        pageobject = Pageobject.new(selector: pageobject_prms[:objectselector], href: pageobject_prms[:objecthref], text: pageobject_prms[:objecttext], page_id: page.id, width: pageobject_prms[:objectwidth], height: pageobject_prms[:objectheight])
        pageobject.save
      end
      # Track
      track = Track.new(actor_id: actor.id, pageobject_id: pageobject.id,
        track_time: pageobject_prms[:tracktime], track_x: pageobject_prms[:track_x], track_y: pageobject_prms[:track_y])
      track.save

      # Movement
      params['movements'].each do |item, v|
        movement = Movement.new(x: v[:x], y: v[:y], time: v[:time], track_id: track.id)
        movement.save
      end

      allmovements = Movement.where(track_id: track.id).all
      #Fix time formatting
      # Additional time spent for actor
      actor.hoursLoggedIn += ( track.track_time - allmovements.first.time.to_d)
      actor.save
     redirect_to '/api'

  end

end
