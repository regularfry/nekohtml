require 'test/helper'
require 'nekohtml'

class TestNekohtml < Test::Unit::TestCase
  def test_nil_content_raises
    assert_raises(ArgumentError) do
      Nekohtml.parse(nil)
    end
  end

  def test_parse_simple_content
    content = "<html><head></head><body></body></html>"
    assert_not_nil Nekohtml.parse(content)
  end

  ###
  # This is something of an integration test
  def test_parse_to_xpath
    content = <<-HTML
    <html>
      <head>
        <title>HTML Page Title</title>
      </head>
      <body>
        <ul>
          <li>Foo</li>
          <li>Bar</li>
        </ul>
      </body>
    </html>
    HTML

    root_node = Nekohtml.parse(content)
    flunk "Bad root node" if root_node.nil?

    xpath = "//LI"

    search_results = root_node.search(xpath)

    assert_equal 2, search_results.length
    assert_equal ["Foo", "Bar"], search_results.map{|r| r.text}
  end

end
