class AddProfileIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :profile_id, :integer
  end
end
