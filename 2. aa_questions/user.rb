require_relative 'questions_database'

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

    def attrs
        { fname: fname, lname: lname }
    end
end