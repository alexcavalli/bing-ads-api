# -*- encoding : utf-8 -*-
module BingAdsApi
	
	
	# Public : This class represents the Customer Management Services 
	# defined in the Bing Ads API, to manage customer accounts 
	# 
	# Author:: jlopezn@neonline.cl 
	# 
	# Examples 
	#  options = {
	#    :environment => :sandbox,
	#    :username => "username",
	#    :password => "pass",
	#    :developer_token => "SOME_TOKEN",
	#    :customer_id => "1234567",
	#    :account_id => "9876543" }
	#  service = BingAdsApi::CustomerManagement.new(options)
	class CustomerManagement < BingAdsApi::Service


		# Public : Constructor 
		# 
		# Author:: jlopezn@neonline.cl 
		# 
		# options - Hash with the parameters for the client proxy and the environment
		# 
		# Examples 
		#   options = {
		#     :environment => :sandbox,
		#     :username => "username",
		#     :password => "password",
		#     :developer_token => "DEV_TOKEN",
		#     :customer_id => "123456",
		#     :account_id => "654321"
		#   }
		#   service = BingAdsApi::CustomerManagement.new(options)
		def initialize(options={})
			super(options)
		end


		#########################
		## Operations Wrappers ##
		#########################

		# Public : Gets a list of objects that contains account identification information, 
		# for example the name and identifier of the account, for the specified customer.
		# 
		# Author:: jlopezn@neonline.cl 
		# 
		# === Parameters
		# +customer_id+ - identifier for the customer who owns the accounts. If nil, then the authentication customer id is used
		# +only_parent_accounts+ - boolean to determine whether to return only the accounts that belong to the customer or to also 
		# return the accounts that the customer manages for other customers. Default false 
		# 
		# === Examples 
		#   customer_management_service.get_accounts_info 
		#   # => Array[BingAdsApi::AccountsInfo]
		# 
		# Returns:: Array of BingAdsApi::AccountsInfo
		# 
		# Raises:: exception
		def get_accounts_info(customer_id=nil, only_parent_accounts=false)
			response = call(:get_accounts_info, 
				{customer_id: customer_id || self.client_proxy.customer_id, 
				only_parent_accounts: only_parent_accounts.to_s})
			response_hash = get_response_hash(response, __method__)
			accounts = response_hash[:accounts_info][:account_info].map do |account_hash|
				BingAdsApi::AccountInfo.new(account_hash)
			end
			return accounts
		end


		private
			def get_service_name
				"customer_management"
			end
			
	end

end
