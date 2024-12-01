# Number Pairs Analyzer

A Ruby-based tool for analyzing and comparing pairs of numbers from historical records. Part of the Advent of Code 2024 Day 1 solution toolkit.

## Features
- Process pairs of 5-digit numbers from text input
- Store and analyze data using SQLite3
- Sort and compare number pairs independently
- Calculate absolute differences between sorted pairs

## Files
- `process_numbers.rb`: Main script for processing input data
- `view_db.rb`: Database inspection utility
- `analyze_pairs.rb`: Advanced analysis and comparison tool

## Usage
```bash
# Process input file and store in database
ruby process_numbers.rb input.txt

# View database contents
ruby view_db.rb

# Analyze sorted pairs and differences
ruby analyze_pairs.rb
```

## Requirements
- Ruby 8+
- SQLite3

## License
This project is licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International - see the [LICENSE](LICENSE) file for details.

![image](https://github.com/user-attachments/assets/2502e4f7-5867-4559-b531-33d3a1f4a1b1)
