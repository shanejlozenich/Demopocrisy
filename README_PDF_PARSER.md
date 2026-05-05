# PDF Parser Documentation

## Overview

The PDF Parser module provides a complete solution for extracting, searching, and managing PDF documents in the Demopocrisy repository. With over 100 PDFs in your collection, these tools make your documents programmable and searchable.

## Installation

```bash
bundle install
```

This installs the `pdf-reader` gem required for PDF text extraction.

## Core Components

### 1. PDFParser Class (`lib/pdf_parser.rb`)

Single PDF processing with methods for text extraction, metadata retrieval, and searching.

#### Basic Usage

```ruby
require_relative 'lib/pdf_parser'

# Initialize parser with PDF file
parser = PDFParser.new("Analysis of Evidence related to HOL 4Culture So.pdf")

# Extract all text
full_text = parser.extract_text

# Extract text by page
pages = parser.extract_text_by_page
# => [{page_number: 1, text: "..."}, {page_number: 2, text: "..."}, ...]

# Get metadata
metadata = parser.extract_metadata
# => {pages: 2, title: "...", author: "...", creator: "...", ...}

# Search for keyword
results = parser.search("majorat")
# => [{page_number: 1, matches: ["...", "..."]}]

# Extract sentences with keyword
sentences = parser.extract_sentences_with_keyword("evidence")

# Export to text file
parser.export_to_text("output.txt")

# Export to JSON
parser.export_to_json("output.json")
```

### 2. BatchPDFProcessor Class (`lib/batch_pdf_processor.rb`)

Process multiple PDFs at once with reporting and indexing.

#### Batch Operations

```ruby
require_relative 'lib/batch_pdf_processor'

processor = BatchPDFProcessor.new(".")

# Process all PDFs in directory
results = processor.process_all_pdfs
# Creates extracted_pdfs/ directory with .txt files

# Generate processing report
report = processor.generate_report
# Saves: extracted_pdfs/processing_report.json

# Create searchable index
index = processor.create_index
# Saves: extracted_pdfs/pdf_index.json

# Search across all PDFs
matches = processor.search_all("majorat")

# Extract content by keyword across all PDFs
content = processor.extract_by_keyword("Sound Transit")

# Get statistics
stats = processor.get_statistics
# => {total_pdfs: 125, total_pages: 8542, ...}
```

## Output Files

After processing, you'll find:

```
extracted_pdfs/
├── processing_report.json     # Processing summary
├── pdf_index.json             # Searchable document index
├── Analysis_of_Evidence...txt # Extracted text from each PDF
└── ...
```

## Examples

### Example 1: Extract Text from Single PDF

```ruby
parser = PDFParser.new("Case Analysis filed 9272025.pdf")
text = parser.extract_text
File.write("extracted.txt", text)
```

### Example 2: Search Multiple Documents

```ruby
processor = BatchPDFProcessor.new(".")
results = processor.search_all("competency")

results.each do |file, matches|
  puts "File: #{file}"
  matches.each do |match|
    puts "  Page #{match[:page_number]}: #{match[:matches]}"
  end
end
```

### Example 3: Extract Specific Content

```ruby
processor = BatchPDFProcessor.new(".")
sentences = processor.extract_by_keyword("due process")

sentences.each do |document, sentences_list|
  puts "\n#{document}:"
  sentences_list.each { |s| puts "  - #{s}" }
end
```

### Example 4: Get Repository Statistics

```ruby
processor = BatchPDFProcessor.new(".")
stats = processor.get_statistics

puts "Total PDFs: #{stats[:total_pdfs]}"
puts "Total Pages: #{stats[:total_pages]}"
puts "Total Characters: #{stats[:total_characters]}"
puts "Avg Pages/PDF: #{stats[:average_pages_per_pdf]}"
```

### Example 5: Process and Report

```ruby
processor = BatchPDFProcessor.new(".")

# Full processing pipeline
report = processor.generate_report
index = processor.create_index

puts "✓ Processed #{report[:successful]} PDFs"
puts "✗ Failed: #{report[:failed]} PDFs"
```

## Advanced Usage

### Custom Keyword Extraction

```ruby
parser = PDFParser.new("document.pdf")

# Get sentences containing "majorat"
majorat_info = parser.extract_sentences_with_keyword("majorat")

majorat_info.each do |sentence|
  puts sentence if sentence.length > 50
end
```

### Page-by-Page Analysis

```ruby
parser = PDFParser.new("document.pdf")
pages = parser.extract_text_by_page

pages.each do |page|
  word_count = page[:text].split.length
  puts "Page #{page[:page_number]}: #{word_count} words"
end
```

### Metadata Extraction

```ruby
parser = PDFParser.new("document.pdf")
meta = parser.extract_metadata

puts "Document: #{meta[:title]}"
puts "Author: #{meta[:author]}"
puts "Created: #{meta[:creation_date]}"
puts "Pages: #{meta[:pages]}"
```

## Error Handling

Both classes include error handling for problematic PDFs:

```ruby
processor = BatchPDFProcessor.new(".")
results = processor.process_all_pdfs

results.each do |result|
  if result[:status] == "error"
    puts "Failed to process #{result[:file]}: #{result[:error]}"
  else
    puts "Successfully processed #{result[:file]}"
  end
end
```

## Performance Tips

1. **Large Batches**: Process PDFs in batches to manage memory
2. **Index Creation**: Create index once, reuse for searching
3. **Storage**: Extracted text files save to `extracted_pdfs/` directory
4. **Search**: Use `search_all()` for first pass, then refine with individual searches

## Troubleshooting

**Issue**: "Gem not found: pdf-reader"
- **Solution**: Run `bundle install`

**Issue**: Permission denied creating output directory
- **Solution**: Ensure write permissions in repository directory

**Issue**: Some PDFs fail to extract
- **Solution**: Check `processing_report.json` for error details; corrupted PDFs may need re-export

## Use Cases for Demopocrisy Repository

1. **Full-text search** across all case documents
2. **Evidence compilation** by extracting keyword-relevant content
3. **Document indexing** for quick reference and analysis
4. **Report generation** with automatic text extraction
5. **Metadata tracking** of all documents with creation/modification dates
6. **Backup and version control** of document content in text format

## Contributing

To extend functionality:

1. Add methods to `PDFParser` for single-PDF operations
2. Add methods to `BatchPDFProcessor` for batch operations
3. Update documentation with new examples
4. Test with sample PDFs from the repository

## License

This code is part of the Demopocrisy repository (CC0 1.0 Universal)
