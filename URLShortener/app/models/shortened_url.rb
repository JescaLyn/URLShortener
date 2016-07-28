class ShortenedUrl < ActiveRecord::Base
  validates :user_id, presence: true
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true, length: { maximum: 1024 }
  validate :submitted_less_than_5_mins_ago

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Tagging

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic

  def submitted_less_than_5_mins_ago
    user = User.find_by(id: self.user_id)
    unless user.urls_submitted_in_last_x_time(1.minute.ago).count < 5
      errors[:base] << "User is too active. Lay off."
    end
  end

  def self.random_code
    short_url = SecureRandom.urlsafe_base64
    while exists?(short_url: short_url)
      short_url = SecureRandom.urlsafe_base64
    end
    short_url
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create(user_id: user.id, long_url: long_url,
      short_url: self.random_code)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques(time)
    self.visits.select(:visitor_id).distinct.where("created_at > '#{time}'").count
  end
end
