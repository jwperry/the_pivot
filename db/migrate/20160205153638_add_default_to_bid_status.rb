class AddDefaultToBidStatus < ActiveRecord::Migration
  def change
    remove_column :bids, :status
    add_column :bids, :status, :integer, default: 0
  end
end
