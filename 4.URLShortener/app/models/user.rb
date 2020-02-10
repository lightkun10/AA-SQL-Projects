# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true

    has_many(:submitted_urls, {
        foreign_key: :submitter_id,
        class_name: 'ShortenedUrl',
        primary_key: :id
    })

    has_many(:visits, {
        foreign_key: :user_id,
        class_name: 'Visit',
        primary_key: :id
    })

    has_many :visited_urls,
        -> { distinct },
        through: :visits,
        source: :shortened_url


end