class AddPostingUrlToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :job_posting_url, :string
  end
end
