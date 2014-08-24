class CreateMixes < ActiveRecord::Migration
  def change
    create_table :mixes do |t|
      t.string :name
      t.belongs_to :user
      
      t.timestamps
    end
  end
end
