class TblExpReason < ActiveRecord::Base
  default_scope { order ('tbl_exp_reasons.Description') }
end
