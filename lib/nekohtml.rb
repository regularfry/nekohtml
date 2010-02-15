require 'celerity'
require 'nekohtml/html_document'

module Nekohtml
  class << self

    def parser()
      configuration = org.cyberneko.html.HTMLConfiguration.new
      jparser = org.apache.xerces.parsers.DOMParser.new(configuration)
      jparser.setProperty("http://cyberneko.org/html/properties/names/elems", "lower");
      jparser.setFeature("http://xml.org/sax/features/namespaces", false)
      return jparser
    end

    # Parse the string. case_sensitive controls whether you can use lower-case xpath
    # elements for tag names or not. case_sensitive=true uses the default NekoHTML
    # parser, which forces everything to be upper case per HTML 4.01. This is a pain.
    def parse(string)
      if string
        jparser = parser()

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
end
