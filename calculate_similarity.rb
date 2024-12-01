require 'sqlite3'

class SimilarityCalculator
  def initialize(db_name = 'number_pairs.db')
    @db = SQLite3::Database.new(db_name)
  rescue SQLite3::Exception => e
    puts "Error accessing database: #{e.message}"
    exit 1
  end

  def calculate_similarity_score
    # Get all numbers from both columns
    left_numbers = @db.execute("SELECT left_num FROM number_pairs").flatten
    right_numbers = @db.execute("SELECT right_num FROM number_pairs").flatten

    # Create frequency map of right numbers
    right_freq = right_numbers.tally

    # Calculate similarity score
    total_score = left_numbers.sum do |left_num|
      # Multiply left number by its frequency in right list (0 if not present)
      left_num * (right_freq[left_num] || 0)
    end

    puts "\nCalculating similarity score..."
    puts "-" * 50
    puts "Total similarity score: #{total_score}"
  end
end

if __FILE__ == $0
  calculator = SimilarityCalculator.new
  calculator.calculate_similarity_score
end
