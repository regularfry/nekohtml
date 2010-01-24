require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
require 'nekohtml/html_document'

class TestHtmlNode < Test::Unit::TestCase
  include Nekohtml

  def setup
    @java_node = stub("(java_node)")
    @node = HtmlNode.new(@java_node)
  end
    
  def test_search
    xpath = "//example/xpath"
    @node.expects(:do_search).with(xpath, 
                                  javax.xml.xpath.XPathConstants::NODESET)

    @node.search(xpath)
  end

  def test_text
    @java_node.expects(:text_content).returns("")
    @node.text
  end

  def test_value
    @java_node.expects(:text_content).returns(nil)
    @node.value
  end


end
