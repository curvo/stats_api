class PageViewSeedSet

  attr_accessor :number_of_seeds
  attr_accessor :end_time
  attr_accessor :start_time
  attr_accessor :end_seconds
  attr_accessor :start_seconds
  attr_accessor :seconds_elapsed
  attr_accessor :starting_primary_key
  attr_accessor :last_primary_key

  DEFAULT_SET_SIZE = 1000
  DEFAULT_DAYS_LIMIT = 5

  def initialize(options={})
    @days_limit = options[:days_limit] || DEFAULT_DAYS_LIMIT
    @number_of_seeds = (options.delete(:number_of_seeds) || DEFAULT_SET_SIZE) - 1
    @end_time = options.delete(:end_time) || Time.now
    @start_time = @end_time - @days_limit.days
    @end_seconds = @end_time.to_i
    @start_seconds = @start_time.to_i
    @seconds_elapsed = @end_time - @start_time
    @last_primary_key = PageView.max(PageView.primary_key) || 0
    PageView.restrict_primary_key? ? PageView.unrestrict_primary_key : false
  end

  def save
    PageView.multi_insert(seeds)
    return seeds.count
  end

  def load_next
    @seeds = load_seeds
  end

  def seeds
    @seeds ||= load_seeds
  end

  def random_attributes
    {
      id: next_primary_key,
      url: random_url,
      referrer: random_referrer,
      created_at: random_timestamp
    }
  end

  def next_primary_key
    @last_primary_key += 1
  end

  def random_url
    PageViewSeeder::URLS[random_url_index]
  end

  def random_url_index
    rand(PageViewSeeder::URLS.size)
  end

  def random_referrer
    PageViewSeeder::REFERRERS[random_referrer_index]
  end

  def random_referrer_index
    rand(PageViewSeeder::REFERRERS.size)
  end

  def load_seeds
    loaded_seeds = *(0..number_of_seeds).inject([]){|a, n| a.push(PageView.new(random_attributes))}
  end

  def random_time_seconds
    (start_seconds + rand(seconds_elapsed))
  end

  def random_timestamp
    Time.at(random_time_seconds).to_datetime
  end

end
