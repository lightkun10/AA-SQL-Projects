# == Schema Information
#
# Table name: taggings
#
#  id               :integer          not null, primary key
#  tag_topic_id     :integer          not null
#  shortened_url_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Tagging < ApplicationRecord
  # one url's tag determined by the tag(s)
  validates :tag_topic, :shortened_url, presence: true
  validates :shortened_url_id, uniqueness: { scope: :tag_topic_id }

  belongs_to :tag_topic,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: 'TagTopic'

  belongs_to :shortened_url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: 'ShortenedUrl'
end