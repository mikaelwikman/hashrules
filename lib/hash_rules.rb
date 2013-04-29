require 'hash_matcher'

class HashRules

  def initialize args
    @folder = args[:folder] || raise("No folder specified!")

    @hashmatcher = HashMatcher.new
    @hashmatcher.include_folder(@folder)
  end

  def process string, opts={}
    Processor.new(string, @hashmatcher, opts).do
  end

  def to_s
    "== HASHRULES ==" << @hashmatcher.to_s
  end

  class Processor
    def initialize string, hashmatcher, opts
      @string = string
      @hashmatcher = hashmatcher
      @max_submatch_level = opts[:max_submatch_level] || 0
      @limit = opts[:limit] || 1
      @memory = []
    end

    def do
      clean_string

      each_submatch_level do |submatch_level|
        remember(new_results = analyze(submatch_level))
        break if reached_limit?
      end

      sort_by_coverage

      remembered_results
    end

    private

    def clean_string
      @string.gsub! /\s+/, ' '
    end

    def analyze submatch_level
      limit = @limit <= 0 ? -1 : results_count() - @limit
      opts = {
        skip_levels: submatch_level,
        limit: limit
      }

      matches = @hashmatcher.analyze(@string, opts)
      matches = matches.delete_if{|m| m['data'].empty?}

      matches.each do |m|
        coverage = Array.new(@string.length, false)
        m['coverage'].each do |start, stop|
          (start..stop).each do |i|
            coverage[i-1] = true
          end
        end
        m['percent_coverage'] = coverage.find_all{|c| c}.count * 100 / @string.length
      end
       
      matches
    end

    def each_submatch_level &block
      (0..@max_submatch_level).each &block
    end

    def reached_limit?
      @limit > 0 && @memory.count >= @limit
    end

    def results_count
      @memory.count
    end

    def remember results
      results.each do |result|
        @memory << result unless @memory.any?{|m| m[:match_id] == result[:match_id]}
      end
    end

    def sort_by_coverage
      @memory.sort!{|a,b| b['percent_coverage'] <=> a['percent_coverage']}
    end

    def remembered_results
      @memory
    end
    
  end
end
