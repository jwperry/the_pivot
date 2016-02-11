class RemoveZipcodeFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :zipcode
  end
end
