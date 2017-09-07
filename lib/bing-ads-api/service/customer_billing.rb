# -*- encoding : utf-8 -*-
module BingAdsApi


	# Public : This class represents the Campaign Management Services
	# defined in the Bing Ads API, to manage advertising campaigns
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
	#  service = BingAdsApi::CampaignManagement.new(options)
	class CustomerBilling < BingAdsApi::Service


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
		#   service = BingAdsApi::CampaignManagement.new(options)
		def initialize(options={})
			super(options)
		end


		#########################
		## Operations Wrappers ##
		#########################


    # Public : Returns all the insertion orders found in the specified account
		#
		# Author:: dmitrii@webstreak.com
		#
		# === Parameters
		# account_id
		#
		# === Examples
		#   customer_billing_service.get_insertion_orders_by_account_id(1)
		#   # => Array[1,2,3]
		#
		# Returns:: Array of Insertion Orders
		#
		# Raises:: exception
		def get_insertion_orders_by_account_id(account_id)
			response = call(:get_insertion_orders_by_account,
			  { account_id: account_id } )
			response_hash = get_response_hash(response, __method__)
			#campaign_ids = response_hash[:campaign_id_collection][:id_collection][:ids][:long]
			#return campaign_ids
      return response_hash
		end

    # Public : Returns insertion orders based on specific conditions
		#
		# Author:: dmitrii@webstreak.com
		#
		# === Parameters
		# ordering
    # page_info
    # predicates
		#
		# Returns:: Array of Insertion Orders
		#
		# Raises:: exception
		def search_insertion_orders(account_id)
      #predicate = BingAdsApi::Predicate.new(field: 'AccountId', operator: 'Equals', value: account_id)
			response = call(:search_insertion_orders,
			  { predicates: {
            predicate: { field: 'AccountId', operator: 'Equals', value: account_id }
          }
        }
      )
			response_hash = get_response_hash(response, __method__)
			#campaign_ids = response_hash[:campaign_id_collection][:id_collection][:ids][:long]
			#return campaign_ids
      return response_hash
		end


    private

      def get_service_name
        "customer_billing"
      end



	end

end
