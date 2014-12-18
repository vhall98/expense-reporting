class CreateReviewers < ActiveRecord::Migration
  def change
    create_table :reviewers do |t|
      t.string :EmployeeID

      t.timestamps
    end
  end
end
