class CreateOpportunityJoinTables < ActiveRecord::Migration[5.2]
  def change
    create_join_table :industries, :opportunities do |t|
      t.index :industry_id
      t.index :opportunity_id
    end
    
    create_join_table :interests, :opportunities do |t|
      t.index :interest_id
      t.index :opportunity_id
    end
    
    create_join_table :locations, :opportunities do |t|
      t.index :location_id
      t.index :opportunity_id
    end
  end
end
