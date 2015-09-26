module Jekyll

	class MaiNavConfig

		attr_reader :conf

		def initialize
		end

	end

   # Add accessor for directory
  class Page
    
    attr_reader :dir, :get_level, :parent, :level, :levels
    attr_writer :parent

    public
  
      ##
      # Get page's level.
      #
      # If level is not set in page's frontmatter then try to extract 
      # it from page's name.
      #
      # @returns  -   Pages outline level
      #
      def get_level
        if self.data["level"].nil?
          @name.split("-").first # NOTE: level separator
        else
          self.data["level"].to_s       
        end
      end

      ##
      # Get page's level length
      #
      # Split page's level and count levels count
      #
      # @returns  -   Page's level's length
      #
      def level
        self.get_level.split(".").length # NOTE: level separator
      end

      ##
      # Get page's levels as array
      #
      # Split page's level into sublevels
      #
      # @returns  -   Page's level's length
      #
      def levels
        self.get_level.split(".") # NOTE: level separator
      end

      #
      # Pages
      #
      #def parent=(page)
      #  @parent = page
      #end

  end
   
end