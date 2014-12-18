class AddTotalToTblReceipt1 < ActiveRecord::Migration
  def change
    add_column :tbl_receipts, :total, :integer
  end
end
