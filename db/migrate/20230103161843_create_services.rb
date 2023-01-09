class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.float :price
      t.text :description
      
      t.belongs_to :isp

      t.timestamps
    end
  end
end
