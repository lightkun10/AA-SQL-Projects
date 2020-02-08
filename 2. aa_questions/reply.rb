require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class Reply
    attr_reader :id
    attr_accessor :question_id, :parent_reply_id, :author_id, :body

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map{ |datum| Reply.new(datum) }
    end

    def initialize(options)
        @id, @question_id, @parent_reply_id, @author_id, @body =
            options.values_at(
              "id", "question_id", "parent_reply_id", "author_id", "body"
            )
    end

    def save
        if @id
            QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id, parent_reply_id: parent_reply_id, author_id: author_id, body: body, id: id)
                UPDATE
                    replies
                SET
                    question_id = :question_id, 
                    parent_reply_id = :parent_reply_id,
                    author_id = :author_id,
                    body = :body
                WHERE
                    replies.id = :id
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id, parent_reply_id: parent_reply_id, author_id: author_id, body: body)
                INSERT INTO
                    replies (question_id, parent_reply_id,author_id, body)
                VALUES
                    (:question_id, :parent_reply_id, :author_id, :body)
            SQL
            @id = QuestionsDatabase.instance.last_insert_row_id
        end
        self
    end

    def self.find(id)
        reply_data = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
            SELECT
                replies.*
            FROM
                replies
            WHERE
                replies.id = :id
        SQL

        reply_data.nil? ? nil : Reply.new(reply_data)
    end

    def self.find_by_user_id(user_id)
        replies_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
            SELECT
                replies.*
            FROM
                replies
            WHERE
                replies.author_id = :user_id
        SQL

        return nil unless replies_data.length > 0
        replies_data.map { |reply_data| Reply.new(reply_data) }
    end

    def self.find_by_question_id(question_id)
        replies_data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
            SELECT
                replies.*
            FROM
                replies
            WHERE
                replies.question_id = :question_id
        SQL

        return nil unless replies_data.length > 0
        replies_data.map { |reply_data| Reply.new(reply_data) }
    end

    def self.find_by_parent_id(parent_id)
        replies_data = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id: parent_id)
            SELECT
                replies.*
            FROM
                replies
            WHERE
                replies.parent_reply_id = :parent_reply_id
        SQL

        return nil unless replies_data.length > 0
        replies_data.map { |reply_data| Reply.new(reply_data) }
    end

    def author    
        User.find_by_id(author_id)
    end

    def parent_reply
        Reply.find(parent_reply_id)
    end

    def child_reply
        Reply.find_by_parent_id(id)
    end
end