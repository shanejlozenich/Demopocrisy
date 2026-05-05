require_relative 'pdf_parser'
require 'json'
require 'fileutils'

class BatchPDFProcessor
  def initialize(directory = ".")
    @directory = directory
    @output_dir = File.join(@directory, "extracted_pdfs")
    FileUtils.mkdir_p(@output_dir) unless Dir.exist?(@output_dir)
  end

  # Process all PDFs in directory
  def process_all_pdfs
    results = []
    Dir.glob("#{@directory}/**/*.pdf").each do |pdf_file|
      begin
        parser = PDFParser.new(pdf_file)
        text = parser.extract_text
        
        # Create output filename based on PDF name
        base_name = File.basename(pdf_file, ".pdf")
        output_file = File.join(@output_dir, "#{base_name}.txt")
        
        # Save extracted text
        File.write(output_file, text)
        
        results << {
          file: pdf_file,
          status: "success",
          pages: parser.extract_metadata[:pages],
          output: output_file
        }
        
        puts "✓ Processed: #{base_name}"
      rescue => e
        results << {
          file: pdf_file,
          status: "error",
          error: e.message
        }
        puts "✗ Error processing #{pdf_file}: #{e.message}"
      end
    end
    results
  end

  # Generate processing report
  def generate_report(format = :json)
    results = process_all_pdfs
    
    report = {
      timestamp: Time.now.iso8601,
      total_files: results.count,
      successful: results.count { |r| r[:status] == "success" },
      failed: results.count { |r| r[:status] == "error" },
      results: results
    }
    
    report_file = File.join(@output_dir, "processing_report.json")
    File.write(report_file, JSON.pretty_generate(report))
    
    puts "\n📊 Report saved to: #{report_file}"
    report
  end

  # Search across all PDFs
  def search_all(keyword)
    matches = {}
    Dir.glob("#{@directory}/**/*.pdf").each do |pdf_file|
      begin
        parser = PDFParser.new(pdf_file)
        results = parser.search(keyword)
        matches[pdf_file] = results if results.any?
      rescue => e
        puts "Error searching #{pdf_file}: #{e.message}"
      end
    end
    matches
  end

  # Create searchable index of all documents
  def create_index
    index = {}
    Dir.glob("#{@directory}/**/*.pdf").each do |pdf_file|
      begin
        parser = PDFParser.new(pdf_file)
        base_name = File.basename(pdf_file, ".pdf")
        
        index[base_name] = {
          file: pdf_file,
          metadata: parser.extract_metadata,
          text_preview: parser.extract_text[0..200] + "..."
        }
      rescue => e
        puts "Error indexing #{pdf_file}: #{e.message}"
      end
    end
    
    index_file = File.join(@output_dir, "pdf_index.json")
    File.write(index_file, JSON.pretty_generate(index))
    
    puts "\n📑 Index created: #{index_file}"
    index
  end

  # Extract specific content by keyword
  def extract_by_keyword(keyword)
    results = {}
    Dir.glob("#{@directory}/**/*.pdf").each do |pdf_file|
      begin
        parser = PDFParser.new(pdf_file)
        sentences = parser.extract_sentences_with_keyword(keyword)
        if sentences.any?
          base_name = File.basename(pdf_file, ".pdf")
          results[base_name] = sentences
        end
      rescue => e
        puts "Error processing #{pdf_file}: #{e.message}"
      end
    end
    results
  end

  # Get statistics about all PDFs
  def get_statistics
    stats = {
      total_pdfs: 0,
      total_pages: 0,
      total_characters: 0,
      average_pages_per_pdf: 0
    }
    
    Dir.glob("#{@directory}/**/*.pdf").each do |pdf_file|
      begin
        parser = PDFParser.new(pdf_file)
        text = parser.extract_text
        
        stats[:total_pdfs] += 1
        stats[:total_pages] += parser.extract_metadata[:pages]
        stats[:total_characters] += text.length
      rescue => e
        puts "Error analyzing #{pdf_file}: #{e.message}"
      end
    end
    
    stats[:average_pages_per_pdf] = stats[:total_pages] / stats[:total_pdfs] if stats[:total_pdfs] > 0
    stats
  end
end
