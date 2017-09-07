# -*- encoding : utf-8 -*-

module BingAdsApi

	##
	# Public : Defines the base object of an location target.
	#
	# Reference: https://msdn.microsoft.com/library/4349d964-0553-4d68-a53e-5011ff51a8f9
	#
	# Author:: seodma@gmailc.com
	#
	class Target < BingAdsApi::DataObject

		attr_accessor :id,
      :location


			# Internal: Retrieve the ordered array of keys corresponding to this data
			# object.
			#
			# Author: alex.cavalli@offers.com
		def to_hash(keys = :camelcase)
			hash = super(keys)
			return hash
    end

    private

#    def get_key_order
#		  super.concat(BingAdsApi::Config.instance.
#			campaign_management_orders['target'])
#		end


	end

	
end
