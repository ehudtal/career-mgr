class CreateMetroOppJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :metros, :opportunities do |t|
      t.index :metro_id
      t.index :opportunity_id
    end
  end
end
