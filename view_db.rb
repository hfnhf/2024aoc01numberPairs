require 'sqlite3'

class DBViewer
  def initialize(db_name = 'number_pairs.db')
    @db = SQLite3::Database.new(db_name)
  rescue SQLite3::Exception => e
    puts "Error accessing database: #{e.message}"
    exit 1
  end

  def show_schema
    puts "\nDatabase Schema:"
    puts "-" * 50
    @db.table_info('number_pairs') do |column|
      puts "#{column['name'].ljust(10)} #{column['type']}"
    end
  end

  def show_all_data
    puts "\nAll Records:"
    puts "-" * 50
    puts "ID    LEFT     RIGHT"
    puts "-" * 50
    
    @db.execute("SELECT * FROM number_pairs") do |row|
      puts "#{row[0].to_s.ljust(6)} #{row[1].to_s.ljust(8)} #{row[2]}"
    end
  end

  def show_counts
    count = @db.get_first_value("SELECT COUNT(*) FROM number_pairs")
    puts "\nTotal Records: #{count}"
  end
end

if __FILE__ == $0
  viewer = DBViewer.new
  viewer.show_schema
  viewer.show_counts
  viewer.show_all_data
end
