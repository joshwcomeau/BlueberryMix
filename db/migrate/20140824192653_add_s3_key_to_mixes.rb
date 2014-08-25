class AddS3KeyToMixes < ActiveRecord::Migration
  def change
    add_column :mixes, :s3_path, :string
  end
end
