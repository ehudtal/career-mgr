class CreateCoachesCohortsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :coaches, :cohorts do |t|
      t.index :coach_id
      t.index :cohort_id
    end
  end
end
