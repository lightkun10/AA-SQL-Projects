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

  


end