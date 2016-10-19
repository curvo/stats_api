class ReportsController < ApplicationController

  def top_urls
    @top_urls = Reports::TopUrls.new
    render json: @top_urls.dataset.to_json
  end

  def top_referrers
    @top_urls_with_referrers = Reports::TopReferrers.new(limit: 10)
    render json: @top_urls_with_referrers.dataset.to_json
  end

end
