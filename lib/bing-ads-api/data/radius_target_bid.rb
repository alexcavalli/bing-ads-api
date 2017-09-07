# -*- encoding : utf-8 -*-

module BingAdsApi

	# Public: Define a bid
	#
	# Author:: alex.cavalli@offers.com
	#
	# Examples
	#   bid = BingAdsApi::Bid.new(:amount => 1.23)
	#   # => <BingAdsApi::Bid>
	class RadiusTargetBid < BingAdsApi::DataObject

		attr_accessor :bid_adjustment,
      :latitude_degrees,
      :longitude_degrees,
      :radius,
      :radius_unit,
      :is_excluded
	  end
    
   def to_hash(keys = :camelcase)
			hash = super(keys)
			return hash
		end

end
