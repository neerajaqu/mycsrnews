class ChirpsController < ApplicationController
  before_filter :login_required, :only => [:create]

  def create
  end
   
end
