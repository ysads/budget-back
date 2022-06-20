class RemoveDeviseFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
  end
end
