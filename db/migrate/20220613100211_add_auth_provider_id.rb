class AddAuthProviderId < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :auth_provider_id, :string
  end
end
