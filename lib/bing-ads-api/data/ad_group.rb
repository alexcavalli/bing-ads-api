# -*- encoding : utf-8 -*-

module BingAdsApi

	# Public : Defines an ad group.
	#
	# Author:: jlopezn@neonline.cl
	#
	# Examples
	#   ad_group = BingAdsApi::AdGroup.new(
	#     :ad_distribution => BingAdsApi::AdGroup::SEARCH,
	#     :language => BingAdsApi::AdGroup::SPANISH,
	#     :name => "Ad Group name",
	#     :pricing_model => BingAdsApi::AdGroup::CPC,
	#     :bidding_model => BingAdsApi::AdGroup::KEYWORD)
	#   # => <BingAdsApi::AdGroup>
	class AdGroup < BingAdsApi::DataObject
		include BingAdsApi::AdDistribution
		include BingAdsApi::AdRotationType
		include BingAdsApi::PricingModel
		include BingAdsApi::BiddingModel
		include BingAdsApi::AdLanguage
		include BingAdsApi::AdGroupStatus


		attr_accessor :id,
			:ad_distribution,
			:ad_rotation,

			:broad_match_bid,
			:content_match_bid,
			:exact_match_bid,
			:phrase_match_bid,
      :search_bid,

			:bidding_model,
			:pricing_model,

			:language,
			:name,
			:status,

			:start_date,
			:end_date



		# Public : Constructor in a ActiveRecord style, with a hash of attributes as input
		#
		# Author:: jlopezn@neonline.cl
		#
		# attributes - Hash with the objects attributes
		def initialize(attributes={})
			super(attributes)
			set_custom_attributes(attributes)
		end


		# Public : Returns this object as a hash to SOAP requests
		# This methods is a specialization for the +DataObject#to_hash+ method
		# that ads specific hash keys for the AdGroup object
		#
		# Author:: jlopezn@neonline.cl
		#
		# keys - specifies the keys case: CamelCase or underscore_case
		#
		# Returns:: Hash
		def to_hash(keys = :underscore)
			hash = super(keys)

			amount_key = get_attribute_key("amount", keys)
			if self.content_match_bid
				#hash.delete(:content_match_bid)
				hash[get_attribute_key("content_match_bid", keys)] = {amount_key => self.content_match_bid}
			end

			if self.exact_match_bid
				hash[get_attribute_key("exact_match_bid", keys)] = {amount_key => self.exact_match_bid}
			end

			if self.phrase_match_bid
				hash[get_attribute_key("phrase_match_bid", keys)] = {amount_key => self.phrase_match_bid}
			end

			if self.broad_match_bid
				hash[get_attribute_key("broad_match_bid", keys)] = {amount_key => self.broad_match_bid}
			end

			if self.start_date
				hash[get_attribute_key("start_date", keys)] = date_to_hash(self.start_date, keys)
			end

			if self.end_date
				hash[get_attribute_key("end_date", keys)] = date_to_hash(self.end_date, keys)
			end

			return hash
		end


		private
			def set_custom_attributes(attributes)
				self.content_match_bid = attributes[:content_match_bid][:amount] if attributes.key?(:content_match_bid)
				self.exact_match_bid = attributes[:exact_match_bid][:amount] if attributes.key?(:exact_match_bid)
				self.phrase_match_bid = attributes[:phrase_match_bid][:amount] if attributes.key?(:phrase_match_bid)
				self.broad_match_bid = attributes[:broad_match_bid][:amount] if attributes.key?(:broad_match_bid)

				if attributes.key?(:start_date) && !attributes[:start_date].nil?
					self.start_date = DateTime.strptime(
						"#{attributes[:start_date][:year]}-#{attributes[:start_date][:month]}-#{attributes[:start_date][:day]}",
						"%Y-%m-%d")
				end

				if attributes.key?(:end_date) && !attributes[:end_date].nil?
					self.end_date = DateTime.strptime(
						"#{attributes[:end_date][:year]}-#{attributes[:end_date][:month]}-#{attributes[:end_date][:day]}",
						"%Y-%m-%d")
				end

			end


			# Internal: Retrieve the ordered array of keys corresponding to this data
			# object.
			#
			# Author: alex.cavalli@offers.com
			def get_key_order
				super.concat(BingAdsApi::Config.instance.
					campaign_management_orders['ad_group'])
			end

	end
end
