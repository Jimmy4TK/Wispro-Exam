class CreateUserServices < ActiveRecord::Migration[7.0]
  def change
    create_table :user_services do |t|
      t.integer :status, default: 0

      t.belongs_to :user
      t.belongs_to :service

      t.timestamps
    end
  end
end
