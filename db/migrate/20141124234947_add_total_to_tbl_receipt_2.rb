class AddTotalToTblReceipt2 < ActiveRecord::Migration
  def change
    add_column :tbl_receipts, :total, :float
  end
end
