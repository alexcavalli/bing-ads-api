# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BingAdsApi::DataObject do
	describe "#to_hash" do

		# TODO: Fix this test to test a "TestDataObject" (the interface) instead of
		# the Campaign object implementation
		it "should return a hash of the object attributes" do
			camp = BingAdsApi::Campaign.new(
				:budget_type => "DailyBudgetStandard",
        :conversion_tracking_enabled => "false",
				:daily_budget => 2000,
				:daylight_saving => "false",
				:description => "Some Campaign",
				:monthly_budget => 5400,
				:name => "Some campaign",
				:status => "Paused",
				:time_zone => "Santiago",
        :campaign_type => "DynamicSearchAds")

			h = camp.to_hash

			expect(h).to be_kind_of(Hash)
			expect(h).not_to be_nil

			expect(h["budget_type"]).to eq(camp.budget_type)
			expect(h["conversion_tracking_enabled"]).to eq(camp.conversion_tracking_enabled)
			expect(h["daily_budget"]).to eq(camp.daily_budget)
			expect(h["daylight_saving"]).to eq(camp.daylight_saving)
			expect(h["description"]).to eq(camp.description)
			expect(h["monthly_budget"]).to eq(camp.monthly_budget)
			expect(h["name"]).to eq(camp.name)
			expect(h["status"]).to eq(camp.status)
			expect(h["time_zone"]).to eq(camp.time_zone)
      expect(h["campaign_type"]).to eq(camp.campaign_type)
	end

	end
end
