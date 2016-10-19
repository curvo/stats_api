class PageView < Sequel::Model

  plugin :timestamps
  plugin :after_initialize

  attr_accessor :referrers
  attr_accessor :count

  def after_initialize
    set_hash
  end

  private

  def set_hash
    self.hash = md5_hash if id.present?
  end

  def hashable_attributes
    {
      id: id,
      url: url,
      referrer: referrer,
      created_at: created_at
    }
  end

  def md5_hash
    Digest::MD5.hexdigest(hashable_attributes.to_s)
  end

end
