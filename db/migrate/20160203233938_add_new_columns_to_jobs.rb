class AddNewColumnsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :city, :string
    add_column :jobs, :state, :string
    add_column :jobs, :zipcode, :integer
    add_column :jobs, :bidding_close_date, :datetime
    add_column :jobs, :must_complete_by_date, :datetime
    add_column :jobs, :duration_estimate, :integer
  end
end
