class DemosController < ApplicationController
  def index
    @demos = demos
  end

  def show
    @demo = params[:id]
  end

  private
  def demos
    [
      'one'
    ]
  end
end
