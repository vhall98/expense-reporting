class RemoveTotalFromTblReceipts < ActiveRecord::Migration
  def up
    remove_column :tbl_receipts, :total
  end

  def down
    add_column :tbl_receipts, :total, :float
  end
end
