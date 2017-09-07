# -*- encoding : utf-8 -*-

module BingAdsApi

	class Predicate < BingAdsApi::DataObject

		attr_accessor :field, :operator, :value

    def to_hash(keys = :underscore)
			hash = super(keys)
			return hash
		end

  private

    def get_key_order
      super.concat(BingAdsApi::Config.instance.
        customer_billing_orders['predicate'])
    end

  end

end
