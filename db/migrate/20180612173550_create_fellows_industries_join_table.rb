class CreateFellowsIndustriesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :fellows, :industries do |t|
      t.index :fellow_id
      t.index :industry_id
    end
  end
end
