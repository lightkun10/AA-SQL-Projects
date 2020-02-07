require_relative 'questions_database'
require_relative 'user'
require_relative 'question'

class QuestionFollow

    def self.followers_for_question_id(question_id)
       # Returns an array of User objects
        users_data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
            SELECT
                users.*
            FROM
                users
            JOIN
                question_follows
            ON
                question_follows.user_id = users.id
            WHERE
                question_follows.question_id = :question_id
        SQL

        return nil unless users_data.length > 0
        users_data.map { |user_data| User.new(user_data) }
    end

    def self.followed_questions_for_user_id(user_id)
        # Returns an array of Question objects.
        questions_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
            SELECT
                questions.*
            FROM 
                questions
            JOIN
                question_follows
            ON
                question_follows.question_id = questions.id
            WHERE
                question_follows.user_id = :user_id
        SQL

        questions_data.map { |question_data| Question.new(question_data) }
    end


end