class TblReceipt < ActiveRecord::Base
  attr_accessible :total, :Amount1, :Amount2, :Amount3, :Amount4, :Amount5, :ApprovedBy, :ApprovedDate, :CategoryID1, :CategoryID2, :CategoryID3, :CategoryID4, :CategoryID5, :Duration, :DurationType, :EmployeeID, :ExpReasonID, :ExportDate, :HaveReceipt, :LocalExpense, :NightsAway, :PaidBy, :Persons, :ProjectDesc, :ProjectID, :Purpose, :ReceiptDate, :ReceiptNo, :State, :Status, :UpdateDate, :UpdateUser, :Vendor
end
