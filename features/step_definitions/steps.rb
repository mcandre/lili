Given(/^the program has finished$/) do
  # Test files are generated using iconv.

  @cucumber = `lili examples/`
  @cucumber_ignore_html = `lili -i '*.html' examples/`
  @cucumber_ignore_html_and_bat =`lili -i '*.html' -i '*.bat' examples/`
  @cucumber_empty = `lili examples/empty.txt`
end

Then(/^the output is correct for each test$/) do
  lines = @cucumber.split("\n")
  expect(lines.length).to eq(122)
  expect(lines[15]).to match(%r(A line ending other than the preferred))

  lines_ignore_html = @cucumber_ignore_html.split("\n")
  expect(lines_ignore_html.length).to eq(26)
  expect(lines_ignore_html[15]).to match(%r(A line ending other than the preferred))

  lines_ignore_html_and_bat = @cucumber_ignore_html_and_bat.split("\n")
  expect(lines_ignore_html_and_bat.length).to eq(15)

  lines_empty = @cucumber_empty.split("\n")
  expect(lines_empty.length).to eq(15)
end
