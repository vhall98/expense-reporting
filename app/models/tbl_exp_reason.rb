class TblExpReason < ActiveRecord::Base
  attr_accessible :Description, :ExpReasonID
  default_scope :order => "tbl_exp_reasons.Description"
end
