class CreateCohortFellows < ActiveRecord::Migration[5.2]
  def change
    create_table :cohort_fellows do |t|
      t.decimal :grade, precision: 8, scale: 4
      t.decimal :attendance, precision: 8, scale: 4
      t.integer :nps_response
      t.integer :endorsement
      t.integer :professionalism
      t.integer :teamwork
      t.text :feedback
      t.integer :fellow_id
      t.integer :cohort_id

      t.timestamps
    end
    
    add_index :cohort_fellows, [:cohort_id, :fellow_id], unique: true
  end
end
