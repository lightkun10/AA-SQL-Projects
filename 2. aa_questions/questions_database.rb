require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

    # def self.execute
    #     instance.execute(*args)
    # end
    
    # def self.get_first_row
    #     instance.get_first_row(*args)
    # end
end