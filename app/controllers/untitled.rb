class ApiController < ApplicationController
  require 'json'
  require 'date'
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def index
    page_specific = Pageobject.where(page_id: 1)
    @pageobjects_x_tracks = page_specific.all.select('*').joins(:tracks)
  end

  #Need to add restriction in terms of user page acces
  #From actor <- track(mouvement) -> pageobject -> page <- User&Actor_page
  def content_access
    actor = Actor.find_by_token(params['actor'])
     page = Page.find_by(href: params['which'])
    @user = User.find_by_token(params['token'])
     if page && ( actor || @user)
      if params['type'] == "trackobjects"
       #Join all the tracks and objects for a page (Total number of clicks but more detailed)
          track_objects = Track.joins('INNER JOIN "pageobjects" ON "pageobjects"."id" = "tracks"."pageobject_id" WHERE "pageobjects"."page_id" = '+page.id.to_s)
          if actor
           track_objects_actor = Track.joins('INNER JOIN "pageobjects" ON "pageobjects"."id" = "tracks"."pageobject_id" INNER JOIN "actors" ON "actors"."id" = "tracks"."actor_id" WHERE "actors"."id" = '+actor.id.to_s+'AND "pageobjects"."page_id" = '+page.id.to_s)
          end
                # Array of hashes{ [OBJ:NB] }
                arrayOfObjectCountHash = Array.new
                objectsCountHash = Hash.new
                if params['op'] && params['op'] == "count"
                    track_objects
                  api_response(track_objects.count)
                elsif params['op'] == "counteach"
                  if
                   track_objects.each do |to|
                      if objectsCountHash[to[:pageobject_id]]
                        #Add
                        objectsCountHash[to[:pageobject_id]] += 1
                      else
                        #Initialise
                        objectsCountHash[to[:pageobject_id]] = 1
                      end
                   end
                   objectsCountHash.keys.each do |k|
                    objectsCountToJsonHash = Hash.new
                    objectsCountToJsonHash[:id] = k
                    objectsCountToJsonHash[:clicks] = objectsCountHash[k]
                    object = Pageobject.find_by(id: k)
                    objectsCountToJsonHash[:tag_id] = object.tagid
                    objectsCountToJsonHash[:text] = object.text
                    objectsCountToJsonHash[:href] = object.href
                    objectsCountToJsonHash[:selector] = object.selector
                    arrayOfObjectCountHash.push(objectsCountToJsonHash)
                   end
                   # arrayOfObjectCountHash.push(objectsCountHash)
                   api_response(arrayOfObjectCountHash.to_json)
                else
                  api_response(track_objects)
                end
      elsif params['type'] = "pageobjects"
          if params['which']
            page = Page.find_by(href: params['which'])
            if page
              # && UserPage.find_by(user_id: @user.id, page_id: page.id)
              objects = Pageobject.where(page_id: page.id)
              if params['op'] == "count"
              api_response(Pageobject.count(page_id: page.id))
              else
              api_response(objects)
              end
            end
          end
      else
      end
  end
    if @user && params['type']
      case params['type']
        when "pages"
          api_response(Page.all)
        when "actorpages"
          if params['which']
              page = Page.find_by(href: params['which'])
              if page
               # && UserPage.find_by(user_id: @user.id, page_id: page.id)
                if params['op'] == "count"
                  api_response(ActorPage.count(page_id: page.id))
                else
                api_response(ActorPage.where(page_id: page.id))
                end
              end
          end
        when "websites"
          api_response(Website.all)
        when "actorwebsites"
          api_response(ActorWebsite.all)
        when "tracks"
           if params['which']
              page = Page.find_by(href: params['which'])
              if page
                #Join all the tracks and objects for a page (Total number of clicks but more detailed)

                track_objects = Track.joins('INNER JOIN "pageobjects" ON "pageobjects"."id" = "tracks"."pageobject_id" WHERE "pageobjects"."page_id" = '+page.id.to_s)
                if params['op'] && params['op'] == "count"
                  api_response(track_objects.count)
                else
                api_response(track_objects)
                end
              end
           else
              api_response(Track.all)
           end
        when "actors"
          if params['which'] && params['op']
            page = Page.find_by(href: params['which'])
            if params['op'] == "count" && page
             # && UserPage.find_by(user_id: @user.id, page_id: page.id)
              api_response(ActorWebsite.count(host: page.host))
            end
          else
            api_response(Actor.all)
          end
        when "movements"
          if params['which']
            page = Page.find_by(href: params['which'])
            if page
              # && UserPage.find_by(user_id: @user.id, page_id: page.id)
              objects = Pageobject.where(page_id: page.id)
              @pageobjects_x_tracks = objects.all.select('*').joins(:tracks, :movements)
              if params['op'] == "count"
                api_response(@pageobjects_x_tracks.count)
              else
               api_response(@pageobjects_x_tracks)
              end
            end
          else
            api_response(Movement.all)
          end
        when "pageobjects"
          if params['which']
            page = Page.find_by(href: params['which'])
            if page
              # && UserPage.find_by(user_id: @user.id, page_id: page.id)
              objects = Pageobject.where(page_id: page.id)
              if params['op'] == "count"
              api_response(Pageobject.count(page_id: page.id))
              else
              api_response(objects)
              end
            end
          else
          api_response(Pageobject.all)
         end
        else
          api_response(Page.all)
      end
    end
  end

  def auth

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
      #website
      website = Website.find_by(host: page_prms[:pagehost])
      if !website
        website = Website.new(host: page_prms[:pagehost])
        website.save
      end
      #actor_website
      actor_website = ActorWebsite.find_by(actor_id: actor.id, website_id: website.id)
      if !actor_website
        actor_website = ActorWebsite.new(actor_id: actor.id, website_id: website.id)
        actor_website.save
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
        pageobject = Pageobject.new(selector: pageobject_prms[:objectselector], tagid: pageobject_prms[:tagid], href: pageobject_prms[:objecthref], text: pageobject_prms[:objecttext], page_id: page.id, width: pageobject_prms[:objectwidth], height: pageobject_prms[:objectheight])
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
