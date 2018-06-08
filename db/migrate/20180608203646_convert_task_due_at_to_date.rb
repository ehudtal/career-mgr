class ConvertTaskDueAtToDate < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :due_at, :date
  end
  
  def down
    change_column :tasks, :due_at, :datetime
  end
end
