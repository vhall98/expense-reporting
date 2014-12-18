class AddTotalToTblReceipt < ActiveRecord::Migration
  def change
    add_column :tbl_receipts, :total, :string
  end
end
