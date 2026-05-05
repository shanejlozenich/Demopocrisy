require_relative '../lib/pdf_parser'
require_relative '../lib/batch_pdf_processor'

puts "=" * 60
puts "PDF Parser Examples"
puts "=" * 60

# Note: Update these paths to actual PDFs in your repository

# Example 1: Extract text from a single PDF
puts "\n[Example 1] Extract text from single PDF"
puts "-" * 60
begin
  parser = PDFParser.new("Analysis of Evidence related to HOL 4Culture So.pdf")
  text = parser.extract_text
  puts "✓ Extracted #{text.length} characters"
  puts "Preview: #{text[0..100]}..."
rescue => e
  puts "Note: PDF file not found. This is a demonstration."
  puts "Usage: parser.extract_text returns all PDF text"
end

# Example 2: Extract metadata
puts "\n[Example 2] Extract PDF metadata"
puts "-" * 60
begin
  parser = PDFParser.new("Case Analysis filed 9272025.pdf")
  metadata = parser.extract_metadata
  puts "✓ Metadata extracted:"
  puts "  - Pages: #{metadata[:pages]}"
  puts "  - Title: #{metadata[:title]}"
  puts "  - Author: #{metadata[:author]}"
rescue => e
  puts "Note: Demonstrates metadata extraction"
  puts "Usage: parser.extract_metadata returns document info"
end

# Example 3: Extract text by page
puts "\n[Example 3] Extract text by page"
puts "-" * 60
puts "✓ Usage:"
puts "  parser.extract_text_by_page"
puts "  Returns: [{page_number: 1, text: '...'}, ...]"

# Example 4: Search within a PDF
puts "\n[Example 4] Search within PDF"
puts "-" * 60
puts "✓ Usage:"
puts "  results = parser.search('majorat')"
puts "  Returns: [{page_number: 1, matches: ['...']}]"

# Example 5: Extract sentences with keyword
puts "\n[Example 5] Extract sentences containing keyword"
puts "-" * 60
puts "✓ Usage:"
puts "  sentences = parser.extract_sentences_with_keyword('evidence')"
puts "  Returns array of sentences containing the keyword"

# Example 6: Export to text
puts "\n[Example 6] Export PDF to text file"
puts "-" * 60
puts "✓ Usage:"
puts "  parser.export_to_text('output.txt')"
puts "  Creates file with full PDF text"

# Example 7: Export to JSON
puts "\n[Example 7] Export PDF to JSON"
puts "-" * 60
puts "✓ Usage:"
puts "  parser.export_to_json('output.json')"
puts "  Creates JSON with metadata and all pages"

# Example 8: Batch processing
puts "\n[Example 8] Process all PDFs in directory"
puts "-" * 60
puts "✓ Usage:"
puts "  processor = BatchPDFProcessor.new('.')"
puts "  results = processor.process_all_pdfs"
puts "  Creates extracted_pdfs/ with .txt files for each PDF"

# Example 9: Search across all PDFs
puts "\n[Example 9] Search across all PDFs"
puts "-" * 60
puts "✓ Usage:"
puts "  matches = processor.search_all('majorat')"
puts "  Returns hash of matching documents and page numbers"

# Example 10: Create document index
puts "\n[Example 10] Create searchable index"
puts "-" * 60
puts "✓ Usage:"
puts "  index = processor.create_index"
puts "  Saves PDF index to extracted_pdfs/pdf_index.json"

puts "\n" + "=" * 60
puts "For full documentation, see: README_PDF_PARSER.md"
puts "=" * 60
