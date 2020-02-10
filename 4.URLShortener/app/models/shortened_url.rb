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

  # Remember, belongs_to is just a method where the first argument is
  # the name of the association, and the second argument is an options
  # hash.

  belongs_to(:submitter, {
    primary_key: :id,
    class_name: 'User',
    foreign_key: :submitter_id
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


end