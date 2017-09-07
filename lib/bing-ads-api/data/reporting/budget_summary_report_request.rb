# -*- encoding : utf-8 -*-

module BingAdsApi

	##
	# Public: Reporting service request object for a keyword performance report.
	#
	# Author:: alex.cavalli@offers.com
	#
	# === Usage
	#
	#   request = BingAdsApi::KeywordPerformanceReportRequest.new(
	#     :format   => :xml,
	#     :language => :english,
	#     :report_name => "Me report",
	#     :aggregation => :hourly,
	#     :columns => [:account_name, :account_number, :time_period],
	#     # The filter is specified as a hash
	#     :filter => {
	#       # specifies the Bing expected String value
	#       :ad_distribution => "Search",
	#       :ad_type => "Text",
	#       :bid_match_type => "Exact",
	#       :delivered_match_type => "Exact",
	#       # specifies criteria as a snake case symbol
	#       :device_type => :tablet,
	#       :keyword_relevance => [3],
	#       :keywords => ["bing ads"],
	#       :landing_page_relevance => [2],
	#       :landing_page_user_experience => [2],
	#       :language_code => ["EN"],
	#       :quality_score => [7,8,9,10] },
	#     :max_rows => 10,
	#     :scope => {
	#       :account_ids => [123456, 234567],
	#       :campaigns => [<BingAdsApi::CampaignReportScope>],
	#       :ad_groups => [<BingAdsApi::AdGroupReportScope>] },
	#     :sort => [<BingAdsApi::KeywordPerformanceReportSort>]
	#     # predefined date
	#     :time => :this_week)
	class BudgetSummaryReportRequest < BingAdsApi::ReportRequest
    
    # Adds helper methods to time attribute
		include BingAdsApi::Helpers::TimeHelper

		# Adds helper methods to column attribute
		include BingAdsApi::Helpers::ColumnHelper
    
    # Adds helper methods to filter attribute
		include BingAdsApi::Helpers::FilterHelper


		# Valid Columns for this report request
		COLUMNS = BingAdsApi::Config.instance.
			reporting_constants['budget_summary_report']['columns']

		# Valid Filters for this report request
		FILTERS = BingAdsApi::Config.instance.
			reporting_constants['budget_summary_report']['filter']

		attr_accessor :max_rows, :sort, :columns, :filter, :scope, :time


		# Public : Constructor. Adds a validations for the columns and filter
		# attributes
		#
		# Author:: alex.cavalli@offers.com
		#
		# === Parameters
		# * +attributes+ - Hash with the report request attributes
		#
		# === Example
		#
		#   request = BingAdsApi::KeywordPerformanceReportRequest.new(
		#     :format   => :xml,
		#     :language => :english,
		#     :report_name => "Me report",
		#     :aggregation => :hourly,
		#     :columns => [:account_name, :account_number, :time_period],
		#     # The filter is specified as a hash
		#     :filter => {
		#       # specifies the Bing expected String value
		#       :ad_distribution => "Search",
		#       :ad_type => "Text",
		#       :bid_match_type => "Exact",
		#       :delivered_match_type => "Exact",
		#       # specifies criteria as a snake case symbol
		#       :device_type => :tablet,
		#       :keyword_relevance => [3],
		#       :landing_page_relevance => [2],
		#       :landing_page_user_experience => [2],
		#       :language_code => ["EN"],
		#       :quality_score => [7,8,9,10] },
		#     :max_rows => 10,
		#     :scope => {
		#       :account_ids => [123456, 234567],
		#       :campaigns => [<BingAdsApi::CampaignReportScope>],
		#       :ad_groups => [<BingAdsApi::AdGroupReportScope>] },
		#     :sort => [<BingAdsApi::KeywordPerformanceReportSort>]
		#     # predefined date
		#     :time => :this_week)
		def initialize(attributes={})
			raise Exception.new("Invalid columns") if !valid_columns(COLUMNS, attributes[:columns])
      raise Exception.new("Invalid time") if !valid_time(attributes[:time])
			super(attributes)
		end


		# Public:: Returns the object as a Hash valid for SOAP requests
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# * +keys_case+ - case for the hashes keys: underscore or camelcase
		#
		# Returns:: Hash
		def to_hash(keys = :underscore)
			hash = super(keys)
			hash[get_attribute_key('columns', keys)] =
				columns_to_hash(COLUMNS, columns, keys)
			hash[get_attribute_key('filter', keys)] =
				filter_to_hash(FILTERS, keys)
			hash[get_attribute_key('scope', keys)] = scope_to_hash(keys)
			hash[get_attribute_key('max_rows', keys)] = max_rows if max_rows
			hash[get_attribute_key('sort', keys)] = sort_to_hash(keys) if sort
			hash["@xsi:type"] = type_attribute_for_soap
      hash[get_attribute_key('time', keys)] = time_to_hash(keys)
			return hash
		end


		private

			# Internal:: Returns the scope attribute as a hash for the SOAP request
			#
			# Author:: alex.cavalli@offers.com
			#
			# === Parameters
			# * +keys_case+ - case for the hash: underscore or camelcase
			#
			# Returns:: Hash
			def scope_to_hash(keys_case=:underscore)
				return {
					get_attribute_key('account_ids', keys_case) =>
						{"ins0:long" => object_to_hash(scope[:account_ids], keys_case) },
					get_attribute_key('campaigns', keys_case) =>
						{ "CampaignReportScope" => object_to_hash(scope[:campaigns], keys_case) }
				}
			end


			# Internal:: Returns the sort attribute as an array for the SOAP request
			#
			# Author:: alex.cavalli@offers.com
			#
			# === Parameters
			# * +keys_case+ - case for the hash: underscore or camelcase
			#
			# Returns:: Array
			def sort_to_hash(keys_case=:underscore)
				sort.map { |sort_object| object_to_hash(sort_object, keys_case) }
			end


			# Internal:: Returns a string with type attribute for the ReportRequest SOAP tag
			#
			# Author:: jlopezn@neonline.cl
			#
			# Returns:: "v9:KeywordPerformanceReportRequest"
			def type_attribute_for_soap
				return BingAdsApi::ClientProxy::NAMESPACE.to_s + ":" +
					BingAdsApi::Config.instance.
						reporting_constants['budget_summary_report']['type']
			end

	end

end
