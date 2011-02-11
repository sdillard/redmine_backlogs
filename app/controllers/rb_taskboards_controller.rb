include RbCommonHelper

class RbTaskboardsController < RbApplicationController
  unloadable
  
  def show
    @statuses     = Tracker.find_by_id(Task.tracker).issue_statuses
    @story_ids    = @sprint.stories.where(:conditions => ['project_id = ANY(SELECT id FROM projects WHERE lft <= (
                    SELECT lft FROM projects WHERE id=?
                ) AND rgt >= (
                    SELECT rgt FROM projects WHERE id=?
                ))',params[:project_id], params[:project_id]]).map{|s| s.id}
    @last_updated = Task.find(:first, 
                              :conditions => ["parent_id in (?)", @story_ids],
                              :order      => "updated_on DESC")
    respond_to do |format|
      format.html { render :layout => "rb" }
    end
  end
  
end
