class StalkController < ApplicationController

  def index
    if params[:q]
      stalkees = params[:q].gsub(/\s/,',').split(',').collect{|item| item.strip.gsub(/^\@/,'')}.reject{|s| s.empty?}.sort
      @subject_count = stalkees.length
      stalker = Stalker.new(stalkees)
      @results = stalker.search
    end
  end

end
