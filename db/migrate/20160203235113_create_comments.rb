class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :recipient_id, index: true
      t.text :text
      t.integer :rating
      t.references :job, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
