# == Schema Information
#
# Table name: visits
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  shortened_url_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# a reminder that visit is the 'Join' table

class Visit < ApplicationRecord
  validates :user_id, :shortened_url_id, presence: true

  belongs_to(:shortened_url, {
    foreign_key: :shortened_url_id,
    class_name: 'ShortenedUrl',
    primary_key: :id
  })

  belongs_to(:visitor, {
    foreign_key: :user_id,
    class_name: 'User',
    primary_key: :id
  })

  def self.record_visit!(user, shortened_url)
    Visit.create!(
      user_id: user.id,
      shortened_url_id: shortened_url.id
    )
  end
end