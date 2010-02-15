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

    xpath = "//li"

    search_results = root_node.search(xpath)

    assert_equal 2, search_results.length
    assert_equal ["Foo", "Bar"], search_results.map{|r| r.text}
  end
  
  def test_html_with_namespaces
    content = <<-HTML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
        <head></head>
      </html>
    HTML

    root_node = Nekohtml.parse(content)
    assert_not_nil root_node

    xpath = "//head"
    search_results = root_node.search(xpath)

    assert_equal 1, search_results.length
  end

  def test_not_case_sensitive
    content = "<html> <head><title>Foo</title></head> <body><h1>Heading</h1></body> </html>"
    root_node = Nekohtml.parse(content)
    xpath = "//h1"
    search_result = root_node.at(xpath)
    assert_not_nil search_result, "Nothing found with the xpath #{xpath}."
    assert_equal "Heading", search_result.text
  end

end
