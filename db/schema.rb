# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141125052849) do

  create_table "employees", :force => true do |t|
    t.string   "EmployeeID"
    t.string   "ReviewerID"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reviewers", :force => true do |t|
    t.string   "EmployeeID"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tbl_categories", :force => true do |t|
    t.string   "Description"
    t.integer  "CategoryID"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tbl_codes", :force => true do |t|
    t.string   "Code_Desc"
    t.integer  "Parent_ID"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tbl_exp_reasons", :force => true do |t|
    t.string   "Description"
    t.integer  "ExpReasonID"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tbl_receipts", :force => true do |t|
    t.datetime "ReceiptDate"
    t.integer  "CategoryID1"
    t.integer  "CategoryID2"
    t.integer  "CategoryID3"
    t.integer  "CategoryID4"
    t.integer  "CategoryID5"
    t.string   "ApprovedBy"
    t.string   "Persons"
    t.string   "ProjectDesc"
    t.string   "ProjectID"
    t.datetime "ApprovedDate"
    t.datetime "ExportDate"
    t.datetime "UpdateDate"
    t.string   "Duration"
    t.string   "DurationType"
    t.string   "EmployeeID"
    t.string   "PaidBy"
    t.string   "NightsAway"
    t.string   "Purpose"
    t.integer  "ExpReasonID"
    t.integer  "HaveReceipt"
    t.integer  "LocalExpense"
    t.string   "State"
    t.string   "Status"
    t.string   "Vendor"
    t.string   "UpdateUser"
    t.integer  "ReceiptNo"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "total"
    t.string   "Amount1"
    t.string   "Amount2"
    t.string   "Amount3"
    t.string   "Amount4"
    t.string   "Amount5"
  end

  create_table "tbl_states", :force => true do |t|
    t.string   "StateAbbr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
