class AddZipcodeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :zipcode, :string
  end
end
