class AddConfirmationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :confirmation, :boolean, default: false
  end
end
