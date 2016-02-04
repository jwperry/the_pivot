class DropObsoleteColumnsFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :image_path
    remove_column :jobs, :price
    remove_column :jobs, :file_upload_file_name
    remove_column :jobs, :file_upload_content_type
    remove_column :jobs, :file_upload_file_size
    remove_column :jobs, :file_upload_updated_at
  end
end
