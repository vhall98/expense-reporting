class CreateTblReceipts < ActiveRecord::Migration
  def change
    create_table :tbl_receipts do |t|
      t.datetime :ReceiptDate
      t.integer :Amount1
      t.integer :Amount2
      t.integer :Amount3
      t.integer :Amount4
      t.integer :Amount5
      t.integer :CategoryID1
      t.integer :CategoryID2
      t.integer :CategoryID3
      t.integer :CategoryID4
      t.integer :CategoryID5
      t.string :ApprovedBy
      t.string :Persons
      t.string :ProjectDesc
      t.string :ProjectID
      t.datetime :ApprovedDate
      t.datetime :ExportDate
      t.datetime :UpdateDate
      t.string :Duration
      t.string :DurationType
      t.string :EmployeeID
      t.string :PaidBy
      t.string :NightsAway
      t.string :Purpose
      t.integer :ExpReasonID
      t.integer :HaveReceipt
      t.integer :LocalExpense
      t.string :State
      t.string :Status
      t.string :Vendor
      t.string :UpdateUser
      t.integer :ReceiptNo

      t.timestamps
    end
  end
end
