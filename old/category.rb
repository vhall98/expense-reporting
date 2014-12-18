class Category < ActiveRecord::Base
  self.table_name = "tbl_categories"
  default_scope :order => "tbl_categories.Description"
end
