class Register
  class ConversionPath
    Conversion = Struct.new(:from, :to, :exchange_rate)

    include Enumerable

    def self.in_path?(from, nodes)
      nodes.map{ |n| n[:from] }.include?(from)
    end

    def initialize(rates_xml, from, to)
      @rates_xml = Nokogiri::XML(File.read(rates_xml))
      @from      = from
      @to        = to
    end

    def nodes
      @nodes ||= find_nodes(@from)
    end

    def each
      nodes.each { |node| yield(node) }
    end

     private

    def find_nodes(from, data=[])
      paths = @rates_xml.xpath("/rates/rate[from='#{from}']")

      node = paths.select { |n| n.xpath("to").text == @to }.first

      unless node.nil?
        return data << conversion(node)
      end

      node = paths.find do |n| 
        not self.class.in_path?(n.xpath("to").text, data)
      end

      find_nodes(node.xpath("to").text, data << conversion(node))
    end

    def conversion(node)
      Conversion.new(node.xpath("from").text,
                     node.xpath("to").text,
                     BigDecimal(node.xpath("conversion").text))
    end
  end
end
