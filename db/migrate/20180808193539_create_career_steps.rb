class CreateCareerSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :career_steps do |t|
      t.integer :fellow_id
      t.integer :position
      t.string :name
      t.string :description
      t.boolean :completed, default: false

      t.timestamps
    end
    add_index :career_steps, :fellow_id
  end
end
