class SettsController < ApplicationController
  def index
    @setts = Sett.all
  end

  def show
    @sett = Sett.find(params[:id])
  end
end