class CreateFellowsOppsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :fellows, :metros do |t|
      t.index :fellow_id
      t.index :metro_id
    end
  end
end
