require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'sys/admin'

Bundler.require(:default, Rails.env)

module ExpenseReporting
  class Application < Rails::Application
    # the new line added for autoload of lib
    config.autoload_paths += %W(#{config.root}/lib)
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline, remove if you're not using in Rails 4
    config.assets.enabled = false

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    # Create mapping to Expense table column names
    config.db_columns = {  :amount        => "Amount",
                           :amount1       => "Amount1",
                           :amount2       => "Amount2",
                           :amount3       => "Amount3",
                           :amount4       => "Amount4",
                           :amount5       => "Amount5",
                           :categoryID    => "CategoryID",
                           :category1     => "CategoryID1",
                           :category2     => "CategoryID2",
                           :category3     => "CategoryID3",
                           :category4     => "CategoryID4",
                           :category5     => "CategoryID5",
                           :codedesc     => "Code_Desc",
                           :date          => "ReceiptDate",
                           :description   => "Description",
                           :duration      => "Duration",
                           :durationtype => "DurationType",
                           :employeeid   => "EmployeeID",
                           :havereceipt  => "HaveReceipt",
                           :local         => "LocalExpense",
                           :paidby       => "PaidBy",
                           :parentid     => "Parent_ID",
                           :persons       => "Persons",
                           :purpose       => "Purpose",
                           :reason        => "ExpReasonID",
                           :receiptno    => "ReceiptNo",
                           :reviewerid   => "ReviewerID",
                           :state         => "State",                   
                           :stateabbr     => "StateAbbr",
                           :status        => "Status",
                           :updateuser   => "UpdateUser",
                           :updatedate   => "UpdateDate",
                           :username      => "username",
                           :vendor        => "Vendor",
                           :updatedat    => "updated_at",
                           :createdat    => "created_at",
                           :id            => "id",
                           :approvedby   => "ApprovedBy",
                           :projectdesc  => "ProjectDesc",
                           :projectid    => "ProjectID",
                           :approveddate => "ApprovedDate",
                           :exportdate   => "ExportDate",
                           :nightsaway   => "NightsAway",
                           :total        => "total"
                 }
  end
end
