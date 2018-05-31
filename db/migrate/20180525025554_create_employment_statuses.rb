class CreateEmploymentStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :employment_statuses do |t|
      t.string :name

      t.timestamps
    end
    
    add_index :employment_statuses, :name, unique: true
  end
end
