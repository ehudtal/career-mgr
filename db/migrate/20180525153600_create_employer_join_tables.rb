class CreateEmployerJoinTables < ActiveRecord::Migration[5.2]
  def change
    create_join_table :coaches, :employers do |t|
      t.index :coach_id
      t.index :employer_id
    end

    create_join_table :industries, :employers do |t|
      t.index :industry_id
      t.index :employer_id
    end

    create_join_table :locations, :employers do |t|
      t.index :location_id
      t.index :employer_id
    end
  end
end
