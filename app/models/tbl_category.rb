class TblCategory < ActiveRecord::Base
  attr_accessible :CategoryID, :Description
  default_scope :order => "tbl_categories.Description"
end
