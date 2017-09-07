# -*- encoding : utf-8 -*-

require 'savon'
require 'bing-ads-api/api_exception'
require 'bing-ads-api/config'
require 'bing-ads-api/constants'
require 'bing-ads-api/service'
require 'bing-ads-api/client_proxy'
require 'bing-ads-api/soap_hasheable'
require 'bing-ads-api/data_object'


# Require services
Dir[File.join(File.dirname(__FILE__), 'bing-ads-api', 'service', '*.rb')].each { |file| require file }

# Require data objects
Dir[File.join(File.dirname(__FILE__), 'bing-ads-api', 'data', '*.rb')].each { |file| require file }

# Require bulk data objects
Dir[File.join(File.dirname(__FILE__), 'bing-ads-api', 'data', 'bulk', '*.rb')].each { |file| require file }


# Require Fault objects
require 'bing-ads-api/fault/application_fault'
require 'bing-ads-api/fault/ad_api_error'
require 'bing-ads-api/fault/ad_api_fault_detail'
require 'bing-ads-api/fault/api_fault_detail'
require 'bing-ads-api/fault/batch_error'
require 'bing-ads-api/fault/operation_error'
require 'bing-ads-api/fault/partial_errors'

# Require Reporting helper objects
Dir[File.join(File.dirname(__FILE__), 'bing-ads-api', 'data', 'reporting', 'helpers', '*.rb')].each { |file| require file }

# Require report request data objects
require 'bing-ads-api/data/reporting/performance_report_request'
require 'bing-ads-api/data/reporting/account_performance_report_request'
require 'bing-ads-api/data/reporting/campaign_performance_report_request'
require 'bing-ads-api/data/reporting/keyword_performance_report_request'
require 'bing-ads-api/data/reporting/share_of_voice_report_request'
require 'bing-ads-api/data/reporting/budget_summary_report_request'
# require 'bing-ads-api/data/reporting/ad_group_performance_report_request'
# require 'bing-ads-api/data/reporting/ad_performance_report_request'

# Public : This is the main namespace for all classes and submodules in this BingAdsApi Gem
#
# Author:: jlopezn@neonline.cl
module BingAdsApi


end
