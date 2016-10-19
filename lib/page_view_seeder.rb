class PageViewSeeder

  attr_accessor :end_time
  attr_accessor :number_of_seeds

  def initialize
    @end_time = Time.now
    @created_seeds = 0
    @number_of_seeds = NUMBER_OF_SEEDS
    puts "Starting Page View Rows: #{PageView.count}"
  end

  def self.generate
    seeder = PageViewSeeder.new
    seeder.generate_seeds
  end

  def self.regenerate
    PageView.truncate
    PageViewSeeder.generate
  end

  def generate_seeds
    number_of_sets.times.each{generate_page_view_seed_set} && print_final_status
  end

  def number_of_sets
    @number_of_sets ||= number_of_seeds/PageViewSeedSet::DEFAULT_SET_SIZE
  end

  def page_view_seed_set
    @page_view_seed_set ||= PageViewSeedSet.new(number_of_seeds: PageViewSeedSet::DEFAULT_SET_SIZE, end_time: end_time)
  end

  def generate_page_view_seed_set
    print_status
    @created_seeds += page_view_seed_set.save
    page_view_seed_set.load_next
  end

  def print_status
    print seed_status
    $stdout.flush
  end

  def print_final_status
    puts "\n\n"
    puts seed_status
    puts "End Page View Rows: #{PageView.count}"
    puts "\nDone!"
  end

  def seed_status
    "Seeds Created: #{@created_seeds}  Seeds to Go: #{seeds_to_go}  Elapsed Seconds: #{elapsed_seconds}  Seconds To Go: " + sprintf('%.2f', predicted_seconds) + "\r"
  end

  def predicted_seconds
    average_time_per_seed * seeds_to_go
  end

  def average_time_per_seed
    (elapsed_seconds.to_f/([@created_seeds,1].max).to_f)
  end

  def seeds_to_go
    [number_of_seeds,1].max - @created_seeds
  end

  def elapsed_seconds
    Time.now.to_i - start_time.to_i
  end

  def start_time
    @start_time ||= Time.now
  end

  def self.generate_random_url
    random_chooser ? generate_random_insecure_url : generate_random_secure_url
  end

  def self.random_chooser
    rand(2) == 1
  end

  def self.generate_random_insecure_url
    Faker::Internet.url(load_random_url_domain)
  end

  def self.generate_random_secure_url
    generate_random_insecure_url.gsub('http://','https://')
  end

  def self.load_random_url_domain
    load_random_required_url.gsub('http://','').gsub('https://','')
  end

  def self.load_random_required_url
    REQUIRED_URLS[rand(REQUIRED_URLS.size)]
  end

  NUMBER_OF_SEEDS = 1000000
  NUMBER_OF_SEED_SETS = NUMBER_OF_SEEDS

  REQUIRED_URLS = [
    'http://apple.com',
    'https://apple.com',
    'https://www.apple.com',
    'http://developer.apple.com',
    'http://en.wikipedia.org',
    'http://opensource.org'
  ]

  EXTRA_URLS = *(0..200).inject([]){|a, n| a.push( PageViewSeeder.generate_random_url )}

  URLS = REQUIRED_URLS + EXTRA_URLS

  REQUIRED_REFERRERS = [
    'http://apple.com',
    'https://apple.com',
    'https://www.apple.com',
    'http://developer.apple.com',
    `NULL`
  ]

  EXTRA_REFERRERS = *(0..25).inject([]){|a, n| a.push(Faker::Internet.url)}

  REFERRERS = REQUIRED_REFERRERS + EXTRA_REFERRERS

end
