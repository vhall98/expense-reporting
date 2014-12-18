class Expense < ActiveRecord::Base
  self.table_name = "tblReceipts"
    attr_accessible :ReceiptNo, :ReceiptDate, :UpdateUser, :EmployeeID, :Status, :HaveReceipt, :CategoryID1, :Amount1
    attr_accessible :ExpReasonID, :CategoryID2, :Amount2, :LocalExpense, :State, :CategoryID3, :Amount3, :PaidBy, :UpdateDate
    attr_accessible :CategoryID4, :Amount4, :Duration, :DurationType, :CategoryID5, :Amount5, :Vendor, :Purpose, :Persons
end
