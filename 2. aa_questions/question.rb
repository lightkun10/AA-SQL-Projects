require_relative 'questions_database'

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

    def attrs
        { title: title, body: body, author_id: author_id }
    end

    def self.find_by_id(id)
        questions_data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
            SELECT 
                questions.*
            FROM 
                questions
            WHERE 
                questions.id = :id
        SQL

        questions_data.map { |question_data| Question.new(question_data) }
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

        questions_data.map { |question_data| Question.new(question_data) }
    end
end