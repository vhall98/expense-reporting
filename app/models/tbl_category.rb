class TblCategory < ActiveRecord::Base
  default_scope { order('tbl_categories.Description') }
end
