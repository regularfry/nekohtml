require 'celerity'
require 'nekohtml/html_document'

module Nekohtml
  def Nekohtml.parse(string)
    if string
      jparser = org.cyberneko.html.parsers.DOMParser.new

      jinput_reader = java.io.StringReader.new(string.to_java_string)
      jinput_source = org.xml.sax.InputSource.new(jinput_reader)
      jparser.parse(jinput_source)
      jdocument = jparser.get_document()
      # We know that the document has successfully been parsed 
      # at this point.

      return HtmlDocument.new(jdocument)
    else
      raise ArgumentError.new
    end
  end
end
