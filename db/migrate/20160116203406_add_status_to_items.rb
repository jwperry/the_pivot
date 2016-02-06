class AddStatusToItems < ActiveRecord::Migration
  def change
    add_column :items, :status, :integer, default: 0
  end
end
