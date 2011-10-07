class StalkController < ApplicationController
  
  def index
    @subject_count = 0
    if params[:q] && !params[:q].empty?
      stalkees = params[:q].gsub(/\s/,',').split(',').collect{|item| item.strip.gsub(/^\@/,'')}.reject{|s| s.empty?}.sort
      @subject_count = stalkees.length
      stalker = Stalker.new(stalkees)
      @results = stalker.search
    end
  end

  def top
    @results = Stalker.top_searches
  end
end
