class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :EmployeeID
      t.string :ReviewerID

      t.timestamps
    end
  end
end
