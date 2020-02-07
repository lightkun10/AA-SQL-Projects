require_relative 'questions_database'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follow'

class Question
    attr_reader :id
    attr_accessor :title, :body, :author_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Question.new(datum) }
    end

    def initialize(options)
        @id, @title, @body, @author_id = 
          options.values_at("id", "title", "body", "author_id")
    end

    def self.find(id)
        question_data = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
            SELECT 
                questions.*
            FROM 
                questions
            WHERE 
                questions.id = :id
        SQL

        question_data.nil? ? nil : Question.new(question_data)
    end

    def self.find_by_author_id(author_id)
        questions_data = QuestionsDatabase.instance.execute(<<-SQL, author_id: author_id)
            SELECT
                questions.*
            FROM
                questions
            WHERE
                questions.author_id = :author_id
        SQL

        return nil unless questions_data.length > 0
        questions_data.map { |q_data| Question.new(q_data) }
    end

    def author
        User.find_by_id(id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def followers
        QuestionFollow.followers_for_question_id(id)
    end
end