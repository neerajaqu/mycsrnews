class ViewObjectsController < ApplicationController
  def index
    render(:text => %{<div id="home_container">#{ViewTree.render(self)}</div>}, :layout => 'application') and return
  end

  def show
    @view_object = ViewObject.find(params[:id])
    respond_to do |format|
      format.html { render(:text => %{<div id="home_container">#{ViewTree.render(@view_object.name, self)}</div>}.html_safe, :layout => 'application') and return }
      format.json { render(:json => ViewTree.render(@view_object.name, self), :layout => false).to_json and return }
    end
  end

  def test
    @view_objects = ViewObject.all
  end
end
