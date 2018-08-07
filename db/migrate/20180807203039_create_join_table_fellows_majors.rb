class CreateJoinTableFellowsMajors < ActiveRecord::Migration[5.2]
  def change
    create_join_table :fellows, :majors do |t|
      t.index [:fellow_id, :major_id]
      t.index [:major_id, :fellow_id]
    end

    create_join_table :majors, :opportunities do |t|
      t.index [:opportunity_id, :major_id]
      t.index [:major_id, :opportunity_id]
    end
  end
end
