class ComparatorController < ApplicationController
  def index
    @tracks = Track.all
    @movements = Movement.all
    @pageobjects = Pageobject.all
    @pageobjects_x_movements = Pageobject.select('*').joins(:tracks)
  end

  def create
    comparator = params[:comparator]
    flash[:optionl] = params[:option]
    flash[:rateofimp] = params[:favoritepage].to_f/100 + 1
    if comparator[:path1] && comparator[:path2]
      page1 = Page.find_by(href: comparator[:path1])
      page2 = Page.find_by(href: comparator[:path2])
      if page1 && page2 && page1.href && page2.href
        #Have to change structure so that this is called in comparator_results
        #once, so I will have to return an array instead.
        page1_info_arr = get_page_specs_of(page1, "allkinds")
        page2_info_arr = get_page_specs_of(page2, "allkinds")
        page1_avg_obj_time = page1_info_arr[5]
        page2_avg_obj_time = page2_info_arr[5]
        page1_avg_obj_required_distance = page1_info_arr[0]
        page2_avg_obj_required_distance = page2_info_arr[0]
        flash[:page1objectfitts] = page1_info_arr[6]
        flash[:page2objectfitts] = page2_info_arr[6]
        flash[:page1] = [page1.href, page1_avg_obj_time, page1_avg_obj_required_distance]
        flash[:page2] = [page2.href, page2_avg_obj_time, page2_avg_obj_required_distance]

      end
    end
    redirect_to '/comparator_results'
  end



  def comparator_results
      @rate_of_importance = flash[:rateofimp]
      @optionl = flash[:optionl]
      @trace_comparer = 0
      @page_objects_common_text = []
      @page1_object_common_text_time = []
      @page2_object_common_text_time = []
      @page1_object_common_text_required_distance = []
      @page2_object_common_text_required_distance = []
      @page1_object_counts = []
      @page2_object_counts = []
      page1_object_height = []
      page2_object_height = []
      @page1_fitts_index_of_difficulty = []
      @page2_fitts_index_of_difficulty = []

      if flash[:page1] && flash[:page2]
      @page1_link = flash[:page1].first
      @page2_link = flash[:page2].first
      flash[:page1].second.each { |k1 , v1|
        object_k1 = Pageobject.find_by(id: k1)
        flash[:page2].second.each { |k2 , v2|
        object_k2 = Pageobject.find_by(id: k2)
          #If user chooses to match texts
          if ((object_k1.tagid == object_k2.tagid && @optionl == "1")||(object_k1.text == object_k2.text && @optionl == "2"))&& object_k1.text.length > 0
            @page_objects_common_text << object_k2.text
            @page1_object_common_text_time << (v1.to_d*3600).round(2)
            @page2_object_common_text_time << (v2.to_d*3600).round(2)
            @page1_object_common_text_required_distance << flash[:page1].third[k1].to_d.round(2)
            @page2_object_common_text_required_distance << flash[:page2].third[k2].to_d.round(2)
            @page1_fitts_index_of_difficulty << flash[:page1objectfitts][k1].to_d.round(3)
            @page2_fitts_index_of_difficulty << flash[:page2objectfitts][k2].to_d.round(3)
        end

          }
        }
      end
  end

  def distance_calc

  end

end
