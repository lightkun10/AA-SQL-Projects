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
        class_name: 'ShortenedUrl',
        foreign_key: :submitter_id,
        primary_key: :id
    })
end