# == Schema Information
#
# Table name: tag_topics
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TagTopic < ApplicationRecord
  validates :name, presence: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: 'Tagging'

  has_many :shortened_urls,
    through: :taggings,
    source: :shortened_url

  def popular_links
    # returns the 5 most visited links for that TagTopic 
    # along with the number of times each link has been clicked.
    shortened_urls.joins(:visits)
      .group(:short_url, :long_url)
      .order('COUNT(visits.id) DESC')
      .select('short_url, long_url, COUNT(visits.id) AS number_of_visits')
      .limit(5)
  end
end


=begin
#  [tag topics]  <=>    [taggings]  <=>  [shortened urls]
#                                              ^^^
#                                              ^^^   
#                                            [visits]

Through shortened_urls => visits association,
Join tag topic with visit table.

With access to long and short url, 
- select the short url and long url, 
  also the total of url visited(use count to the id),
- group by the short and long url from the most to least,
- order by the amount of the visited id
- limit by 5

=end