class AddResumeUrlToFellows < ActiveRecord::Migration[5.2]
  def change
    add_column :fellows, :resume_url, :string
  end
end
