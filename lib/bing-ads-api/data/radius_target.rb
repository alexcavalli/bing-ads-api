# -*- encoding : utf-8 -*-

module BingAdsApi

	##
	# Public : Defines the base object of an ad.
	# Do not instantiate this object. Instead you can instantiate the
	# BingAdsApi::TextAd, BingAdsApi::MobileAd, or BingAdsApi::ProductAd
	# object that derives from this object.
	#
	# Reference: http://msdn.microsoft.com/en-US/library/bing-ads-campaign-management-ad.aspx
	#
	# Author:: jlopezn@neonline.cl
	#
	class RadiusTarget < BingAdsApi::DataObject

		attr_accessor :bids
    
    def to_hash(keys = :camelcase)
			hash = super(keys)
			return hash
    end

	end

end
