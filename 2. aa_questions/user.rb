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

    def self.find_by_id(id)
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

    def 
end