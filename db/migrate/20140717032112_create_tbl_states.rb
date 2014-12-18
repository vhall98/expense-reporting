class CreateTblStates < ActiveRecord::Migration
  def change
    create_table :tbl_states do |t|
      t.string :StateAbbr

      t.timestamps
    end
  end
end
