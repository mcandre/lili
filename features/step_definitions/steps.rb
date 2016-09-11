Given(/^the program has finished$/) do
  # Test files are generated using iconv.

  @cucumber = `lili examples/`
  @cucumber_ignore_html = `lili -i '*.html' examples/`
  @cucumber_ignore_html_and_bat =`lili -i '*.html' -i '*.bat' examples/`
  @cucumber_empty = `lili examples/empty.txt`
  @cucumber_stat = `lili -s examples/`
  @cucumber_stat_ignore_html = `lili -s -i '*.html' examples/`
end

Then(/^the output is correct for each test$/) do
  lines = @cucumber.split("\n")
  expect(lines.length).to eq(9)
  expect(lines[0]).to match(%r(^examples/hello-wrong.bat\:.+$))

  lines_ignore_html = @cucumber_ignore_html.split("\n")
  expect(lines_ignore_html.length).to eq(1)
  expect(lines_ignore_html[0]).to match(%r(examples/hello-wrong.bat\:.+$))

  lines_ignore_html_and_bat = @cucumber_ignore_html_and_bat.split("\n")
  expect(lines_ignore_html_and_bat.length).to eq(0)

  lines_empty = @cucumber_empty.split("\n")
  expect(lines_empty.length).to eq(0)

  lines_stat = @cucumber_stat
  expect(valid_json?(lines_stat)).to eq(true)

  json = JSON.parse(lines_stat)
  expect(json['findings'].length).to eq(9)
  expect(json['findings'][0]['location']['path']).to match('examples/hello-wrong.bat')

  lines_stat_ignore_html = @cucumber_stat_ignore_html
  expect(valid_json?(lines_stat_ignore_html)).to eq(true)

  json = JSON.parse(lines_stat_ignore_html)
  expect(json['findings'].length).to eq(1)
  expect(json['findings'][0]['location']['path']).to match('examples/hello-wrong.bat')

end

def valid_json?(json)
  begin
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end
