class AddPortalCourseIdToFellows < ActiveRecord::Migration[5.2]
  def change
    add_column :fellows, :portal_course_id, :integer
  end
end
