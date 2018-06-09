class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :due_at
      t.boolean :completed, default: false
      t.text :notes
      t.integer :taskable_id
      t.string :taskable_type

      t.timestamps
    end
    
    add_index :tasks, :due_at
    add_index :tasks, :completed
    add_index :tasks, [:taskable_id, :taskable_type]
  end
end
