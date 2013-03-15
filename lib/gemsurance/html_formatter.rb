module Gemsurance
  class HtmlFormatter
    def initialize(gem_data)
      @gem_data = gem_data
    end
    
    def format
      ERB.new(File.read(File.join(File.dirname(File.expand_path(__FILE__)), 'templates/output.html.erb'))).result(binding)
    end
  end
end
