require 'sqlite3'

class NumberProcessor
  def initialize(db_name = 'number_pairs.db')
    @db_name = db_name
  end

  def reset_database
    # Drop and recreate the database
    File.delete(@db_name) if File.exist?(@db_name)
    @db = SQLite3::Database.new(@db_name)
    
    @db.execute <<-SQL
      CREATE TABLE number_pairs (
        id INTEGER PRIMARY KEY,
        left_num INTEGER NOT NULL,
        right_num INTEGER NOT NULL
      );
    SQL
    puts "Database reset complete"
  end

  def validate_and_store(filename)
    unless File.exist?(filename)
      puts "Error: File '#{filename}' not found"
      return false
    end

    # Validation pattern: 5 digits, exactly 3 spaces, 5 digits
    valid_pattern = /^\d{5}\s{3}\d{5}$/
    valid_pairs = []
    
    File.readlines(filename, chomp: true).each_with_index do |line, index|
      unless line.match?(valid_pattern)
        puts "Error on line #{index + 1}: '#{line}' doesn't match expected format"
        next
      end
      
      left, right = line.split(/\s+/).map(&:to_i)
      valid_pairs << [left, right]
    end

    if valid_pairs.empty?
      puts "No valid number pairs found"
      return false
    end

    # Store in database
    @db.transaction do
      valid_pairs.each do |left, right|
        @db.execute(
          "INSERT INTO number_pairs (left_num, right_num) VALUES (?, ?)",
          [left, right]
        )
      end
    end

    puts "\nProcessed #{valid_pairs.size} valid pairs"
    true
  end

  def display_sorted_data
    puts "\nInput data preview (first 10 rows):"
    @db.execute("SELECT left_num, right_num FROM number_pairs LIMIT 10").each do |row|
      puts "#{row[0]}   #{row[1]}"
    end

    puts "\nLeft numbers sorted ascending:"
    @db.execute("SELECT left_num FROM number_pairs ORDER BY left_num").each do |row|
      puts row[0]
    end

    puts "\nRight numbers sorted ascending:"
    @db.execute("SELECT right_num FROM number_pairs ORDER BY right_num").each do |row|
      puts row[0]
    end
  end
end

# Example usage
if __FILE__ == $0
  if ARGV.empty?
    puts "Usage: ruby process_numbers.rb <input_file>"
    exit 1
  end

  begin
    processor = NumberProcessor.new
    processor.reset_database
    if processor.validate_and_store(ARGV[0])
      processor.display_sorted_data
    end
  rescue SQLite3::Exception => e
    puts "Database error occurred: #{e.message}"
  end
end