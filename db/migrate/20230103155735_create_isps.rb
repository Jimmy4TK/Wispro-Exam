class CreateIsps < ActiveRecord::Migration[7.0]
  def change
    create_table :isps do |t|
      t.string :name
      t.string :password_digest
      t.string :token

      t.timestamps
    end
  end
end
