require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'

class User
    attr_reader :id
    attr_accessor :fname, :lname

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map{ |datum| User.new(datum) }
    end
    
    def initialize(options)
        @id, @fname, @lname =
            options.values_at("id", "fname", "lname")
    end

    def save
        # update existing data
        # create new
        if @id
            QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname, id: id)
                UPDATE
                    users
                SET
                    fname = :fname, lname = :lname
                WHERE
                    users.id = :id
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
                INSERT INTO
                    users (fname, lname)
                VALUES
                    (:fname, :lname)
            SQL
            @id = QuestionsDatabase.instance.last_insert_row_id
        end
        self
    end

    def self.find(id)
        user_data = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
            SELECT
                users.*
            FROM
                users
            WHERE
                users.id = :id
        SQL

        user_data.nil? ? nil : User.new(user_data)
    end

    def self.find_by_name(fname, lname) 
        #fname = first name, lname = last name
        attrs = { fname: fname, lname: lname }

        user_data = QuestionsDatabase.instance.get_first_row(<<-SQL, attrs)
            SELECT
                users.*
            FROM
                users
            WHERE
                users.fname = :fname AND users.lname = :lname
        SQL

        user_data.nil? ? nil : User.new(user_data)
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(id)
    end

    def average_karma
        # returns two things: 
        # the number of questions asked by a user
        # the number of likes on those questions.
        QuestionsDatabase.instance.get_first_value(<<-SQL, author_id: self.id)
            SELECT
                CAST(COUNT(question_likes.id) AS FLOAT) /
                COUNT(questions.id) 
                AS average_karma
            FROM
                questions
            LEFT OUTER JOIN
                question_likes
            ON
                question_likes.question_id = questions.id
            WHERE
                questions.author_id = :author_id
        SQL
    end

end