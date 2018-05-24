class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :semester
      t.integer :year
      t.integer :site_id

      t.timestamps
    end
    
    add_index :courses, :site_id
  end
end
