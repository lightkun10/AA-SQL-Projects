# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string           not null
#  short_url    :string           not null
#  submitter_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# 'validates' for normal validation
# 'validate' for custom validation methods


class ShortenedUrl < ApplicationRecord
  validates :short_url, :long_url, :submitter_id, presence: true
  validates :short_url, uniqueness: true

  belongs_to(:submitter, {
    foreign_key: :submitter_id,
    class_name: 'User',
    primary_key: :id
  })

  has_many(:visits, {
    foreign_key: :shortened_url_id,
    class_name: 'Visit',
    primary_key: :id
  })

  has_many(:visitors, {
    through: :visits,
    source: :visitor
  })

  def self.create_for_user_and_long_url(user, long_url)
    # User.create_for_user_and_long_url(user_pandu, "kajsajskasjka.com")
    ShortenedUrl.create!(
      submitter_id: user.id,
      long_url: long_url,
      short_url: ShortenedUrl.random_code
    )
  end

  def self.random_code
    loop do
      random_code = SecureRandom.urlsafe_base64(16)

      # Handle the vanishingly small possibility that a code 
      # has already been taken: keep generating codes until we find 
      # one that isn't the same as one already stored as the short_url 
      # of any record in our table. Return the first unused random code.
      if !ShortenedUrl.exists?(short_url: random_code)
        return random_code
      end
    end
  end

  def num_clicks
  end

end