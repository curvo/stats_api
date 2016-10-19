class Reports::TopUrls

  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :limit

  URLS_LIMIT = 25
  DAYS_LIMIT = 5

  def initialize(options={})
    @days_limit = options[:days_limit] || DAYS_LIMIT
    @end_date = options[:end_date] || Time.now.to_date
    @start_date = options[:start_date] || end_date - DAYS_LIMIT.days
    @limit = options[:limit] || URLS_LIMIT
  end

  def dataset
    @dataset ||= load_dataset
  end

  def days
    @days ||= load_days.reverse
  end

  private

  def load_dataset
    days.inject({}) do |day_hash, date|
      report_data = load_report_data(date)
      report_data.present? ? day_hash.merge({date.to_s => report_data}) : day_hash
    end
  end

  def load_report_data(date)
    load_top_urls(date)
  end

  def load_top_urls(date)
    PageView.where(['DATE(created_at) = :date', {date: date}]).group_and_count(:url).reverse_order{[count(:url)]}.limit(limit).all
  end

  def load_days
    set_of_days = *(start_date..end_date)
  end

end
