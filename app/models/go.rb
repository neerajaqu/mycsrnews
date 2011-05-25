class Go < ActiveRecord::Base
  acts_as_featured_item
  acts_as_moderatable

  belongs_to :user
  belongs_to :goable, :polymorphic => true, :touch => true

  validates_presence_of :name, :goable
  validates_format_of :name, :with => /^[A-Za-z0-9_-]+$/, :message => "Name must be letters, numbers, dashes or underscores"

  has_friendly_id :name, :use_slug => true

  after_save :set_in_redis

  def viewed!
    Go.increment_counter(:views_count, self.id)
    $redis.incr "gos:views:#{self.cache_id}"
  end

  private

    def set_in_redis
      $redis.set "gos:views:#{self.cache_id}", 0
    end

end
