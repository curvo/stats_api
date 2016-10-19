require "rails_helper"

RSpec.describe Reports::TopUrls, :type => :model do

  before :each do
    PageView.truncate
  end

  describe "when it is initialized" do
    it "sets the end date to today's date if no end_date is passed in" do
      top_url_report = Reports::TopUrls.new
      expect(top_url_report.end_date).to eq(Time.now.to_date)
    end
    it "sets the end date to :end_date if it is passed in" do
      end_date = Time.now.to_date - 3.days
      top_url_report = Reports::TopUrls.new(end_date: end_date)
      expect(top_url_report.end_date).to eq(end_date)
    end
    it "sets the start date to be Reports::TopUrls::DAYS_LIMIT days before the end date if no :start_date is passed in" do
      top_url_report = Reports::TopUrls.new
      expect(top_url_report.start_date).to eq(Time.now.to_date - Reports::TopUrls::DAYS_LIMIT.days)
    end
    it "sets the start date to be :start_date if it's passed in" do
      start_date = Time.now.to_date - 25.days
      top_url_report = Reports::TopUrls.new(start_date: start_date)
      expect(top_url_report.start_date).to eq(start_date)
    end
    it "sets the limit to be Reports::TopUrls::URLS_LIMIT if :limit is not passed in" do
      top_url_report = Reports::TopUrls.new
      expect(top_url_report.limit).to eq(Reports::TopUrls::URLS_LIMIT)
    end
    it "sets the start date to be :start_date if it's passed in" do
      limit = 2
      top_url_report = Reports::TopUrls.new(limit: limit)
      expect(top_url_report.limit).to eq(limit)
    end
  end

  describe "#dataset method" do
    it "calls the load_dataset method and sets the dataset instance variable" do
      top_url_report = Reports::TopUrls.new
      fake_dataset = PageViewSeeder::URLS[0..10].map{|url| {url: url, count: rand(100)}}.sort{|a,b| b[:count]<=>a[:count]}
      top_url_report.stub(:load_dataset) { fake_dataset }
      expect(top_url_report.dataset).to eq(fake_dataset)
      expect(top_url_report.instance_variable_get(:@dataset)).to eq(fake_dataset)
    end
  end

  describe "#days method" do
    it "calls load_days and reverses the order" do
      top_url_report = Reports::TopUrls.new
      fake_days = *((Time.now.to_date - 5.days)..Time.now.to_date)
      top_url_report.stub(:load_days) { fake_days }
      expect(top_url_report.days).to eq(fake_days.reverse)
      expect(top_url_report.instance_variable_get(:@days)).to eq(fake_days.reverse)
    end
  end

  describe "#load_dataset method" do
    it "returns a hash with the days as keys and the values as the values as hashes of urls and counts" do
      PageView.truncate
      seedset = PageViewSeedSet.new(number_of_seeds: 10, end_date: Time.now, days_limit: 0)
      seedset.save
      top_url_report = Reports::TopUrls.new(limit: 1, days_limit: 1)
      dataset = top_url_report.send(:load_dataset)
      expect(dataset.is_a?(Hash)).to be(true)
      expect(dataset.values.first.is_a?(Array)).to be(true)
      expect(dataset.values.first[0].is_a?(PageView)).to be(true)
      expect(dataset.values.first[0][:count].present?).to be(true)
    end
  end

  describe "#load_top_urls method" do
    it "loads page views for date passed grouped and sorted in descending order by view count" do
      PageView.truncate
      seedset = PageViewSeedSet.new(number_of_seeds: 5, end_date: Time.now, days_limit: 0)
      test_url_1 = "http://apple.com"
      test_url_2 = "http://itunes.com"
      test_url_3 = "http://icloud.com"

      seedset.stub(:random_url) {test_url_1}
      5.times{ seedset.save; seedset.load_next }
      seedset.stub(:random_url) {test_url_2}
      3.times{ seedset.save; seedset.load_next }
      seedset.stub(:random_url) {test_url_3}
      2.times{ seedset.save; seedset.load_next }
      seedset.save

      top_url_report = Reports::TopUrls.new(limit: 25)
      top_urls = top_url_report.send(:load_top_urls, Time.now.to_date)
      test_url_1_page_views = PageView.where(['url = :url', {url: test_url_1}]).all
      expect(top_urls.first[:url]).to eq(test_url_1)
      expect(top_urls.first[:count]).to eq(test_url_1_page_views.count)
    end
  end
end
