class CreateAccessTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :access_tokens do |t|
      t.string :code
      t.text :routes

      t.timestamps
    end
    
    add_index :access_tokens, :code, unique: true
  end
end
