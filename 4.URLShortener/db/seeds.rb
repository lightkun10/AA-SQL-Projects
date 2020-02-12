# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.transaction do
  u1 = User.create!(email: 'lifeisubw@gmail.com')
  u2 = User.create!(email: 'bradisrad@gmail.com')
  u3 = User.create!(email: 'howtostopabom@gmail.com')

  # u1 = User.first
  # u2 = User.second
  # u3 = User.third

  su1 = ShortenedUrl.create_for_user_and_long_url(
    u1, 'iz-one.co.kr/en/'
  )

  su2 = ShortenedUrl.create_for_user_and_long_url(
    u2, 'www.github.com'
  )

  su3 = ShortenedUrl.create_for_user_and_long_url(
    u3, 'www.google.com'
  )

  # su1 = ShortenedUrl.first
  # su2 = ShortenedUrl.second
  # su3 = ShortenedUrl.third

  Visit.record_visit!(u1, su1)
  Visit.record_visit!(u2, su1)
  Visit.record_visit!(u3, su3)
  Visit.record_visit!(u2, su1)
  Visit.record_visit!(u3, su3)
  Visit.record_visit!(u1, su2)
  Visit.record_visit!(u2, su1)
  Visit.record_visit!(u1, su2)
  Visit.record_visit!(u2, su3)

  # Visit.record_visit!(u1, su1)
  # Visit.record_visit!(u1, su2)
  # Visit.record_visit!(u2, su1)
  # Visit.record_visit!(u3, su2)
  # Visit.record_visit!(u3, su2)


  tt1 = TagTopic.create!(name: 'Music')
  tt2 = TagTopic.create!(name: 'Development')
  tt3 = TagTopic.create!(name: 'Search')

  # tt1 = TagTopic.first
  # tt2 = TagTopic.second
  # tt3 = TagTopic.second

  Tagging.create!(shortened_url: su1, tag_topic: tt1)
  Tagging.create!(shortened_url: su2, tag_topic: tt2)
  Tagging.create!(shortened_url: su3, tag_topic: tt3)
  # tg1 = Tagging.first
  # tg2 = Tagging.second
  # tg3 = Tagging.third
end