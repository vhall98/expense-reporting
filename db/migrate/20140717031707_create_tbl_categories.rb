class CreateTblCategories < ActiveRecord::Migration
  def change
    create_table :tbl_categories do |t|
      t.string :Description
      t.integer :CategoryID

      t.timestamps
    end
  end
end
