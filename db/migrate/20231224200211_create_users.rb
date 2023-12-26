class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :password_digest, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
