class RemoveTokenFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :token, :string
  end
end
