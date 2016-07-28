class Visit < ActiveRecord::Base
  validates :shortened_url_id, :visitor_id, presence: true

  belongs_to :shortened_url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: "ShortenedUrl"

  belongs_to :visitor,
    primary_key: :id,
    foreign_key: :visitor_id,
    class_name: "User"

  def self.record_visit!(user, shortened_url)
    Visit.create!(visitor_id: user.id, shortened_url_id: shortened_url.id)
  end
end
