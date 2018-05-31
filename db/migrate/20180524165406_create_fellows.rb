class CreateFellows < ActiveRecord::Migration[5.2]
  def change
    create_table :fellows do |t|
      t.string :key
      t.string :first_name
      t.string :last_name
      t.integer :graduation_year
      t.string :graduation_semester
      t.integer :graduation_fiscal_year
      t.text :interests_description
      t.string :major
      t.text :affiliations
      t.decimal :gpa
      t.string :linkedin_url
      t.text :staff_notes
      t.decimal :efficacy_score
      t.integer :employment_status_id

      t.timestamps
    end
    
    add_index :fellows, :key, unique: true
    add_index :fellows, :employment_status_id
  end
end
