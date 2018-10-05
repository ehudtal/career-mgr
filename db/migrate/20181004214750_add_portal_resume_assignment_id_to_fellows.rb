class AddPortalResumeAssignmentIdToFellows < ActiveRecord::Migration[5.2]
  def change
    add_column :fellows, :portal_resume_assignment_id, :integer
  end
end
