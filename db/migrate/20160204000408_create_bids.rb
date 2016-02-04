class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :user, index: true, foreign_key: true
      t.references :job, index: true, foreign_key: true
      t.integer :price
      t.integer :duration_estimate
      t.text :details
      t.string :status
    end
  end
end
