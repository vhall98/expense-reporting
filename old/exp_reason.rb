class ExpReason < ActiveRecord::Base
  self.table_name = 'tbl_exp_reasons'
  default_scope :order => "tbl_exp_reasons.Description"
end
