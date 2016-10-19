class Reports::TopUrls

  attr_accessor :start_date
  attr_accessor :end_date

  def initialize(options={})
    @end_date = options['end_date'] || Time.now.to_date
    @start_date = options['start_date'] || end_date - 5.days
  end

  def pages
    # PageView.where(['DATE(created_at) <= :end_date AND DATE(created_at) >= :start_date', {end_date: end_date, start_date: start_date}])
  end

end
