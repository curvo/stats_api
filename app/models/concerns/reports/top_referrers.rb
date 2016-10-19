class Reports::TopReferrers < Reports::TopUrls

  REFERRERS_LIMIT = 5

  private

  def load_report_data(date)
    tmp_top_urls = load_top_urls(date).each{|pv| pv.referrers = load_top_referrers(pv[:url], date)}
    tmp_top_urls.inject([]){|top_urls_array, pv| top_urls_array.push(for_json(pv)) }
  end

  def for_json(pv)
    {
      url: pv[:url],
      count: pv[:count],
      referrers: pv.referrers.inject([]){|inner_array, pvr| inner_array.push(for_referrer_json(pvr)) }
    }
  end

  def for_referrer_json(pvr)
    {
      url: pvr[:referrer],
      count: pvr[:count]
    }
  end

  def load_top_referrers(url, date)
    PageView.where(['DATE(created_at) = :date AND url = :url', {date: date, url: url}]).group_and_count(:referrer).reverse_order{[count(:referrer)]}.limit(5).all
  end

end
