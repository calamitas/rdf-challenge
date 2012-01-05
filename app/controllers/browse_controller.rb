class BrowseController < ApplicationController
  
  def index
    redirect_to browse_object_path("root")
  end
  
  def object
    @object = find_by_id
  end
  
  def relation
    @object = find_by_id
    @relation_name = params[:relation]
    @relation = @object.outgoing(@relation_name).paginate(:page => params[:page], :per_page => 5)
  end
  
private
  
  def find_by_id
    if params[:id] == "root"
      ModelTypes.new(browse_object_url("root"))
    elsif /\A[a-zA-Z_]+\z/ === params[:id]
      ModelType.new(browse_object_url(params[:id]))
    else
      Neo4j::Rails::Model.find(params[:id])
    end
  end
  
end
