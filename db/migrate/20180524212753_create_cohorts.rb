class CreateCohorts < ActiveRecord::Migration[5.2]
  def change
    create_table :cohorts do |t|
      t.string :name
      t.integer :course_id

      t.timestamps
    end
    
    add_index :cohorts, :course_id
  end
end
