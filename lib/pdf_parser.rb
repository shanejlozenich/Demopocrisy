require 'pdf-reader'
require 'json'

class PDFParser
  def initialize(file_path)
    @file_path = file_path
    @reader = PDF::Reader.new(file_path)
  end

  # Extract all text from PDF
  def extract_text
    text = ""
    @reader.pages.each do |page|
      text += page.text + "\n"
    end
    text
  end

  # Extract text by page
  def extract_text_by_page
    pages = []
    @reader.pages.each_with_index do |page, index|
      pages << {
        page_number: index + 1,
        text: page.text
      }
    end
    pages
  end

  # Get metadata
  def extract_metadata
    {
      pages: @reader.page_count,
      title: @reader.info[:Title],
      author: @reader.info[:Author],
      creator: @reader.info[:Creator],
      producer: @reader.info[:Producer],
      creation_date: @reader.info[:CreationDate],
      modification_date: @reader.info[:ModDate]
    }
  end

  # Search for keywords in PDF
  def search(keyword)
    results = []
    @reader.pages.each_with_index do |page, index|
      text = page.text
      if text.downcase.include?(keyword.downcase)
        results << {
          page_number: index + 1,
          matches: text.scan(/[^.!?]*#{Regexp.escape(keyword)}[^.!?]*/i)
        }
      end
    end
    results
  end

  # Extract text and save to file
  def export_to_text(output_path)
    File.write(output_path, extract_text)
  end

  # Export as JSON
  def export_to_json(output_path)
    data = {
      metadata: extract_metadata,
      pages: extract_text_by_page
    }
    File.write(output_path, JSON.pretty_generate(data))
  end

  # Extract sentences containing keyword
  def extract_sentences_with_keyword(keyword)
    sentences = []
    extract_text.split(/[.!?]+/).each do |sentence|
      if sentence.downcase.include?(keyword.downcase)
        sentences << sentence.strip
      end
    end
    sentences
  end
end
