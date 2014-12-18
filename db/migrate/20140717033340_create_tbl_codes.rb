class CreateTblCodes < ActiveRecord::Migration
  def change
    create_table :tbl_codes do |t|
      t.string :Code_Desc
      t.integer :Parent_ID

      t.timestamps
    end
  end
end
