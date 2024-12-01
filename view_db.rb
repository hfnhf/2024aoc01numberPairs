require 'sqlite3'

class DBViewer
  def initialize(db_name = 'number_pairs.db')
    @db = SQLite3::Database.new(db_name)
  rescue SQLite3::Exception => e
    puts "Error accessing database: #{e.message}"
    exit 1
  end

  private

  def spacerLine
    puts "-" * 50
  end

  public

  def show_schema
    puts "\nDatabase Schema:"
    spacerLine
    @db.table_info('number_pairs') do |column|
      puts "#{column['name'].ljust(10)} #{column['type']}"
    end
  end

  def show_all_data
    puts "\nAll Records:"
    spacerLine
    puts "ID    LEFT     RIGHT"
    spacerLine
    
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
