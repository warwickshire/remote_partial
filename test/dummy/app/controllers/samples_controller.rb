class SamplesController < ApplicationController
  def index
    @samples = samples
  end

  def show
    @sample = params['id']
  end

  private
  def samples
    [
      'one'
    ]
  end
end
