require 'rubygems'
require 'ptools'
require 'line-detector'

require 'version'

DEFAULT_IGNORES = %w(
  \.hg/
  \.svn/
  \.git/
  \.git
  \.gitignore
  node_modules/
  \.vagrant/
  Gemfile\.lock
  \.exe
  \.bin
  \.pdf
  \.png
  \.jpg
  \.jpeg
  \.min.js
  -min\.js
)

#
# Note that order is significant;
# Only the earliest file pattern match's rule applies.
#
DEFAULT_RULES = [
  [/[\.-]min\./, /^none$/],
  [/\.reg$/, /^crlf$/],
  [/\.bat$/, /^crlf$/],
  [/\.ps1$/, /^crlf$/],
  [/.*/, /^lf$/]
]

# Warning for files that do not exist
NO_SUCH_FILE = 'does not exist'

#
# Parse, model, and print a line ending.
# Distinct from Ruby's built-in Encoding class.
#
class ALineEnding
  attr_accessor :filename, :line_ending

  def self.parse(filename, line_ending)
    ALineEnding.new(filename, line_ending.to_s)
  end

  def initialize(filename, line_ending)
    @filename = filename
    @line_ending = line_ending
  end

  def violate?(rules)
    preferred = rules.select { |rule| filename =~ rule.first }.first[1]

    if ! (line_ending =~ preferred)
      [line_ending, preferred]
    else
      false
    end
  end

  def to_s(line_ending_difference = false)
    if line_ending_difference
      observed = line_ending_difference[0]
      preferred = line_ending_difference[1].inspect

      if observed == NO_SUCH_FILE
        "#{@filename}: #{NO_SUCH_FILE}"
      else
        "#{@filename}: observed #{observed} preferred: #{preferred}"
      end
    else
      "#{@filename}: #{@line_ending}"
    end
  end
end

def self.recursive_list(directory, ignores = DEFAULT_IGNORES)
  Find.find(directory).reject do |f|
    File.directory?(f) ||
    ignores.any? { |ignore| f =~ /#{ignore}/ } ||
    File.binary?(f)
  end
end

def self.check(filename, rules = DEFAULT_RULES)
  if !File.zero?(filename)
    line_ending = ALineEnding.parse(
      filename,
      LineDetector.detect_line_ending_of_file(filename)
      )

    line_ending_difference = line_ending.violate?(rules)

    puts line_ending.to_s(line_ending_difference) if line_ending_difference
  end
end
