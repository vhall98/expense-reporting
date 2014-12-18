class RemoveAmountsFromTblReceipt < ActiveRecord::Migration
  def up
    remove_column :tbl_receipts, :Amount1
    remove_column :tbl_receipts, :Amount2
    remove_column :tbl_receipts, :Amount3
    remove_column :tbl_receipts, :Amount4
    remove_column :tbl_receipts, :Amount5
  end

  def down
    add_column :tbl_receipts, :Amount5, :integer
    add_column :tbl_receipts, :Amount4, :integer
    add_column :tbl_receipts, :Amount3, :integer
    add_column :tbl_receipts, :Amount2, :integer
    add_column :tbl_receipts, :Amount1, :integer
  end
end
