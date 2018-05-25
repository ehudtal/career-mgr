class CreateFellowsInterestsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :fellows, :interests do |t|
      t.index :fellow_id
      t.index :interest_id
    end
  end
end
