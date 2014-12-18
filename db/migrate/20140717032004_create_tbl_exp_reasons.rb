class CreateTblExpReasons < ActiveRecord::Migration
  def change
    create_table :tbl_exp_reasons do |t|
      t.string :Description
      t.integer :ExpReasonID

      t.timestamps
    end
  end
end
