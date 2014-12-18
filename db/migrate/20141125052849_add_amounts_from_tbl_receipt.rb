class AddAmountsFromTblReceipt < ActiveRecord::Migration
  def change
    add_column :tbl_receipts, :Amount1, :string
    add_column :tbl_receipts, :Amount2, :string
    add_column :tbl_receipts, :Amount3, :string
    add_column :tbl_receipts, :Amount4, :string
    add_column :tbl_receipts, :Amount5, :string
  end
end
