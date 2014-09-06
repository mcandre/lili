require 'rubygems'
require 'ptools'
require 'line-detector'

require 'version'

DEFAULT_IGNORES = %w(
  \.hg/
  \.svn/
  \.git/
  \.gitignore
  node_modules/
  bower_components/
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
  [/[\.-]min\./, [/^none$/, /^false$/]],
  [/\.reg$/, [/^crlf|none$/, /^false$/]],
  [/\.bat$/, [/^crlf|none$/, /^false$/]],
  [/\.ps1$/, [/^crlf|none$/, /^false$/]],
  [/.*/, [/^lf|none$/, /^true$/]]
]

DEFAULT_CONFIGURATION = {
  'rules' => DEFAULT_RULES
}

# Warning for files that do not exist
NO_SUCH_FILE = 'does not exist'

#
# Parse, model, and print a line ending.
# Distinct from Ruby's built-in Encoding class.
#
class ALineEnding
  attr_accessor :filename, :line_ending, :final_eol

  def self.parse(filename, report)
    ALineEnding.new(filename, report.line_ending.to_s, report.final_eol.to_s)
  end

  def initialize(filename, line_ending, final_eol)
    @filename = filename
    @line_ending = line_ending
    @final_eol = final_eol
  end

  def violate?(rules)
    preferred = rules.select { |rule| filename =~ rule.first }.first[1]

    preferred_line_ending = preferred[0]
    preferred_final_eol = preferred[1]

    if ! (@line_ending =~ preferred_line_ending)
      [@line_ending, preferred_line_ending]
    elsif ! (@final_eol =~ preferred_final_eol)
      [
        if !final_eol
          'with final eol'
        else
          'without final eol'
        end,
        preferred_final_eol
      ]
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

def self.check(filename, configuration = DEFAULT_CONFIGURATION)
  rules = configuration['rules']

  if !File.zero?(filename)
    line_ending = ALineEnding.parse(
      filename,
      LineDetector.report_of_file(filename)
      )

    line_ending_difference = line_ending.violate?(rules)

    puts line_ending.to_s(line_ending_difference) if line_ending_difference
  end
end
