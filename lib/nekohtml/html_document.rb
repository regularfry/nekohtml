module Nekohtml
  class HtmlThing

    attr_accessor :java_object
    def initialize(java_object)
      @java_object = java_object

      @jxpath_factory =
        javax.xml.xpath.XPathFactory.newInstance()
    end

    def do_search(xpath, settings)
      jxpath_object = @jxpath_factory.newXPath()
      jmaybe_node_list = begin
                           jxpath_object.evaluate(
                             xpath, 
                             @java_object,
                             settings
                           )
                         rescue
                           nil
                         end
      return jmaybe_node_list
    end

    def search(xpath)
      @jxpath_settings = javax.xml.xpath.XPathConstants::NODESET
      jnode_list = self.do_search(xpath, @jxpath_settings)

      result = jnode_list ? HtmlNodeList.new(jnode_list) : nil
    end

    def at(xpath)
      @jxpath_settings = javax.xml.xpath.XPathConstants::NODE
      jnode = self.do_search(xpath, @jxpath_settings)

      result = jnode ? HtmlNode.new(jnode) : nil
    end
  end

  class HtmlDocument < HtmlThing; end

  class HtmlNodeList < HtmlThing
    # @java_object is a NodeList in this case
    include Enumerable

    def initialize(*args)
      super
      # Just an alias
      @jnode_list = @java_object
    end

    def length
      @jnode_list.getLength()
    end

    def each
      @jnode_list.getLength().times do |i|
        yield HtmlNode.new(@jnode_list.item(i))
      end
    end
  end

  class HtmlNode < HtmlThing
    def initialize(java_object)
      super
      @jelement = @java_object
    end

    def text
      @jelement.text_content
    end
    def value
      return self.text
    end
  end

end
