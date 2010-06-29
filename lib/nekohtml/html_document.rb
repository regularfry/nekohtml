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
      jnode_list = self.do_search(xpath, javax.xml.xpath.XPathConstants::NODESET)

      result = jnode_list ? HtmlNodeList.new(jnode_list) : nil
    end

    def at(xpath)
      jnode = self.do_search(xpath, javax.xml.xpath.XPathConstants::NODE)

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

    def absolute_xpath
      current_jnode = @jelement
      document = current_jnode.owner_document

      s = ''
      while current_jnode != document
        t = current_jnode.tag_name

        parent_jnode = current_jnode.parent_node
        current_sib = parent_jnode.get_first_child
        relevant_count = 0
        current_jnode_index = 0

        while current_sib 
          if current_sib == current_jnode
            current_jnode_index = relevant_count
            break
          end
          
          if current_sib.tag_name == current_jnode.tag_name
            relevant_count += 1
          end
          current_sib = current_sib.get_next_sibling
        end

        istr = ''
        if relevant_count > 0
          if current_jnode_index > 0
            istr = "[#{current_jnode_index+1}]"
          end
        end

        s = '/' + current_jnode.tag_name + istr + s
        current_jnode = current_jnode.parent_node
      end
      
      return '/' + s

    end

  end

end
