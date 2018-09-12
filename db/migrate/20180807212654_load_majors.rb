class LoadMajors < ActiveRecord::Migration[5.2]
  def change
    Major.reset_column_information
    Major.load_from_yaml
  end
end
