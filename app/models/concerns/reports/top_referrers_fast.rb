class Reports::TopReferrersFast < Reports::TopUrls

  REFERRERS_LIMIT = 5

  private

  def load_top_urls(date)
    top_urls_dataset(date).from_self().group_and_count{[:create_date, :url]}.select_more{[group_concat(referrer, ',', count).as(:referrers)]}.reverse_order{[count(:referrer)]}.limit(URLS_LIMIT).all
  end

  def referrers_dataset(date)
    PageView.where{['DATE(created_at) = :date', {date: date}]}.group_and_count{[date(:created_at).as(:create_date), :url, :referrer]}.reverse_order{[count(:referrer)]}
  end

  def load_top_urls(date)
    top_urls_dataset(date).from_self().group_and_count{[:create_date, :url]}.select_more{[group_concat(referrer, ',', count).as(:referrers)]}.reverse_order{[count(:referrer)]}.limit(URLS_LIMIT).all
  end

  def top_urls_dataset(date)
    PageView.where{['DATE(created_at) = :date', {date: date}]}.group_and_count{[date(:created_at).as(:create_date), :url]}.reverse_order{[count(:url)]}.limit(URLS_LIMIT)
  end

end
