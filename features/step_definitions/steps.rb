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
end
