class ChangeBidStatusToInteger < ActiveRecord::Migration
  def change
    remove_column :bids, :status
    add_column :bids, :status, :integer
  end
end
