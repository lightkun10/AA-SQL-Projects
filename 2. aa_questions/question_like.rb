require_relative 'questions_database'
require_relative 'user'
require_relative 'question'
require_relative 'question_follow'

class QuestionLike
    def self.likers_for_question_id(question_id)
        users_data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
            SELECT
                users.*
            FROM
                users
            JOIN
                question_likes
            ON
                question_likes.user_id = users.id
            WHERE
                question_likes.question_id = :question_id
        SQL

        return nil unless users_data.length > 0
        users_data.map { |user_data| User.new(user_data) }
    end

    # QuestionLike::num_likes_for_question_id(question_id)
    def self.num_likes_for_question_id(question_id)
        QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
            SELECT
                COUNT(*) AS likes
            FROM
                questions
            JOIN
                question_likes
            ON
                question_likes.question_id = questions.id
            WHERE
                questions.id = :question_id
        SQL
    end

    def self.liked_questions_for_user_id(user_id)
        questions_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes
            ON
                question_likes.question_id = questions.id
            WHERE
                question_likes.user_id = :user_id
        SQL

        questions_data.map { |question_data| Question.new(q_data) }
    end

    # QuestionLike::most_liked_questions(n)
    def self.most_liked_questions(n)
        questions_data = QuestionsDatabase.instance.execute(<<-SQL, limit: n)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes
            ON
                question_likes.question_id = questions.id
            GROUP BY
                questions.id
            ORDER BY
                COUNT(*) DESC 
            LIMIT
                :limit
        SQL

        questions_data.map { |question_data| Question.new(question_data) }
    end
end