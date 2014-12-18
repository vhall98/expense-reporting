class TblCode < ActiveRecord::Base
  attr_accessible :Code_Desc, :Parent_ID
  self.table_name = 'tbl_codes'
end
