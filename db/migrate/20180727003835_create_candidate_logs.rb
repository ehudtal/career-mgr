class CreateCandidateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :candidate_logs do |t|
      t.integer :candidate_id
      t.string :status

      t.timestamps
    end
    add_index :candidate_logs, :candidate_id
  end
end
