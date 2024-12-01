require 'sqlite3'

class PairAnalyzer
  def initialize(db_name = 'number_pairs.db')
    @db = SQLite3::Database.new(db_name)
  rescue SQLite3::Exception => e
    puts "Error accessing database: #{e.message}"
    exit 1
  end

  def display_analysis
    # Show input data preview
    puts "\nInput data preview (first 10 rows):"
    puts "-" * 50
    @db.execute("SELECT left_num, right_num FROM number_pairs LIMIT 10").each do |row|
      puts "#{row[0]}   #{row[1]}"
    end

    # Get sorted arrays
    left_sorted = @db.execute("SELECT left_num FROM number_pairs ORDER BY left_num").map(&:first)
    right_sorted = @db.execute("SELECT right_num FROM number_pairs ORDER BY right_num").map(&:first)

    # Calculate differences
    differences = left_sorted.zip(right_sorted).map { |l, r| (l - r).abs }

    # Display sorted columns and differences
    puts "\nSorted columns with differences:"
    puts "-" * 50
    puts "Left     Right    |Diff|"
    puts "-" * 50
    
    left_sorted.zip(right_sorted, differences).each do |left, right, diff|
      puts "#{left.to_s.ljust(8)} #{right.to_s.ljust(8)} #{diff}"
    end

    # Show total difference
    puts "-" * 50
    puts "Total difference: #{differences.sum}"
  end
end

if __FILE__ == $0
  analyzer = PairAnalyzer.new
  analyzer.display_analysis
end
