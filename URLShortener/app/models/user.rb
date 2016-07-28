class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  has_many :submitted_urls,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :ShortenedUrl

  has_many :visits,
    primary_key: :id,
    foreign_key: :visitor_id,
    class_name: :Visit

  has_many :visited_urls,
    -> { distinct },
    through: :visits,
    source: :shortened_url

  def urls_submitted_in_last_x_time(time)
    self.submitted_urls.where("created_at > '#{time}'")
  end
end
