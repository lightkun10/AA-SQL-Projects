class Enrollment < ApplicationRecord
    # each user enrolled on each course
    # Remember, belongs_to is just a method where the first argument is
    # the name of the association, and the second argument is an options
    # hash.

    belongs_to(:user, {
        class_name: 'User',
        foreign_key: :student_id,
        primary_key: :id
    })
    

    belongs_to(:course, {
        class_name: 'Course',
        foreign_key: :course_id,
        primary_key: :id
    })
end
