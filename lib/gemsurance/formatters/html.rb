module Gemsurance
  module Formatters
    class Html < Base
      def format
        @extension = "html"
        ERB.new(File.read(output_path), nil, '-').result(binding)
      end
    end
  end
end
