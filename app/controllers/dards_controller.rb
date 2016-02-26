class DardsController < ApplicationController
  def show
    @dard = Dard.find(params[:id])
  end
end