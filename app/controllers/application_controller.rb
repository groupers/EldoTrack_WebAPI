class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  def current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :authenticate_user!, :current_user
  after_action :set_access_control_headers

  def authenticate_user!
    redirect_to login_path unless current_user
  end
 def set_access_control_headers
   headers['Access-Control-Allow-Origin'] = "*"
   headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
 end
  def api_response(items)
      respond_to do |format|
        format.html
        format.js
        format.json do
          render json: items
        end
      end
  end
  def authorize
    redirect_to '/login' unless current_user
  end

    def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end


  def get_page_specs_of(page, kind)
    if page && page.id
    pageobjects = Pageobject.where(page_id: page.id)
    end
    if pageobjects
      pageobjects_x_tracks = pageobjects.select('*').joins(:tracks)

      total_time_on_page = 0

      total_numb_of_objects = 0


      total_numb_of_track_per_object = Hash.new
      total_time_per_objects = Hash.new
      avg_track_time_per_object = Hash.new

      avg_distance_required_per_object = Hash.new
      avg_distance_taken_per_object = Hash.new

      fitts_index_of_difficulty_per_object = Hash.new
      fitts_index_of_difficulty_sum_per_object = Hash.new

      #Should add a table and column on track to avoid recalculating known avg

        pageobjects_x_tracks.each do |l|
          if l[:id]
            allmovements = Movement.where(track_id: l[:id]).all
            firstmovementtime = Movement.first.time
            #Fix time formatting
            track = Track.find_by(id: l[:id])
            current_track_time = (track.track_time - firstmovementtime.to_d)*3600
            total_time_on_page += current_track_time
            total_numb_of_objects += 1
            current_track_distance = Math.sqrt(((track.track_x - allmovements[0][:x])**2)+((track.track_y-allmovements[0][:y])**2))

            #Since the track distance is approximated to the center of the button
            #Fitts law is applicable. the height will play as W (since its shorter.)
            if !fitts_index_of_difficulty_sum_per_object[l[:pageobject_id]]
             fitts_index_of_difficulty_sum_per_object[l[:pageobject_id]] ||= (Math.log2(2*current_track_distance.to_d/l[:height])).to_d
            else
             fitts_index_of_difficulty_sum_per_object[l[:pageobject_id]] += (Math.log2(2*current_track_distance.to_d/l[:height])).to_d
            end

            if !total_time_per_objects[l[:pageobject_id]]
              total_time_per_objects[l[:pageobject_id]] ||= current_track_time
            else
              total_time_per_objects[l[:pageobject_id]] += current_track_time
            end

            if !total_numb_of_track_per_object[l[:pageobject_id]]
              total_numb_of_track_per_object[l[:pageobject_id]] ||= 1
            else
              total_numb_of_track_per_object[l[:pageobject_id]] += 1
            end

            # avg_distance_required_per_track
            if !avg_distance_required_per_object[l[:pageobject_id]]
              avg_distance_required_per_object[l[:pageobject_id]] ||= current_track_distance
            else
              avg_distance_required_per_object[l[:pageobject_id]] += current_track_distance
            end
          end
        end

          fitts_index_of_difficulty_sum_per_object.each { |k,v|
            fitts_index_of_difficulty_per_object[k] = ((v).to_d)/total_numb_of_track_per_object[k]
          }
          avg_distance_required_per_object.each {|k,v|
            avg_distance_required_per_object[k] = (v)/(total_numb_of_track_per_object[k])
          }
          #Avg time per object
          total_time_per_objects.each { |k, v|
            avg_track_time_per_object[k]= v/total_numb_of_track_per_object[k]

          }
        return case
          #
          when kind == "avg_obj_required_distance"; avg_distance_required_per_object #0
          when kind == "tot_obj_time"; total_time_per_objects #1
          when kind == "tot_obj_numb"; total_numb_of_objects #2
          when kind == "total_numb_of_track_per_object"; total_numb_of_track_per_object #3
          when kind == "tot_page_time"; total_time_on_page #4
          when kind == "avg_obj_time"; avg_track_time_per_object #5
          when kind == "fitts_index_of_difficulty_per_object"; fitts_index_of_difficulty_per_object #6
          when kind == "allkinds"; [avg_distance_required_per_object, total_time_per_objects, total_numb_of_objects,total_numb_of_track_per_object, total_time_on_page, avg_track_time_per_object, fitts_index_of_difficulty_per_object]
          else ; avg_distance_required_per_object
        end
    end
  end

end
