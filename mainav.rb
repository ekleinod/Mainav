#
# Mainav - simple nesting navigation menu tag for Jekyll
# 
# Mainav enables you to create navigation menus for pages and 
# even have them nesting.
#
# @author Aksel Meola <aksel@meola.eu>
# @version 0.1-refurbish
# @date 24.09.15
#
# @licence: One of those it's free and don't sue licences. 
#
# 

module Jekyll


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
   
  module MaiNav
    
    #
    # Object to hold information about a node in a page
    #
    class MaiNavPages
      
      attr_reader :current, :pages

      #""
      # Init Pages object and assign pages for internal work 
      #
      def initialize(site_pages, current_page)
        @pages = site_pages
        @current = current_page
        
        # Calculate deepest level
        self.deepest_level
      end

      ##
      # Scan pages and find each pages parent and children.
      #
      #
      def render_outline(pages)

      end  



      public 

        ##
        # Get all pages in certain category.
        #
        # @param  - Name of the category
        #
        # @returns  - Pages in given category or [] if none found.
        #
        def by_category(category)
          @pages.select { |page|
            !page.data["category"].nil? && page.data["category"] == category }
        end


        ##
        # Get deepest level in set of pages
        #
        # @param  - List of pages to search from
        #
        # @returns  - Deepest level
        #
        def deepest_level
          if @deepest_level.nil?
            @deepest_level = 0
            
            @pages.each{|page|
              if page.level > @deepest_level
                @deepest_level = page.level
              end  
            }
            
            @deepest_level
          else
            @deepest_level
          end
        end
        
        #
        # Find a parent for given page
        #
        def find_parent_for(spage)

          parent = MaiNavPages.suggest_parent_for(spage)

          @pages.each{|page|
            if page.get_level == parent # && page.data['category'] == spage.data["parent"] # NOTE: category check must be done
              return page
            end
          }

          return nil

        end

        ##
        # Get pages by level from given pages
        # Page level is determined by 
        #
        # @param  - List of pages to select from
        # @param  - What level pages to get
        #
        # @returns  - Pages on given lavel
        #
        def MaiNavPages.by_level(pages, level)
          pages.select{|page|
            page.level == level }
        end

        ##
        # Get pages by level from given pages
        # Page level is determined by 
        #
        # @param  - Page to seggest level string for
        #
        # @returns  - Suggested parent level
        #
        def MaiNavPages.suggest_parent_for(page)
          if page.level > 1
            page.levels.take(page.level-1).join(".") # NOTE: level separator
          else
            "top_level"
          end
        end


    end




    #
    # Category navigation
    # 
    # Generate nesting navigation menu out of pages in same category.
    # By default current page's category is chosen but this can be overrided by adding a
    # category parameter to the tag. 
    #
    # 
    class CatNavTag < Liquid::Tag


      #
      # Tag to use in liquid templates to call category navigation
      #
      TAG_NAME = 'catnav'

      #
      # Page delimiter
      #
      @@delimiter = "."     # NOTE: level separator
      @@id_delimiter = "-"  # NOTE: level separator

      @@t = ""
      #
      # Initilize class
      #
      def initialize(tag_name, args, tokens)
        super
   
        @classnames = nil
        @category   = nil


        # Scan for tag arguments
        args.scan(Liquid::TagAttributes) do |key, value|  
          
          if key == "class"
            @classnames = value.tr("\"'", "");
          end

          if key == "category"
            @category = value.tr("\"'", "");
          end
            
        end


      end

      #
      # Render naviation menu
      #
      def render(context)

        site = context.registers[:site]
        current_page = context.registers[:page]
        
        #pages = pages_with_category(site.pages, (@category || current_page["category"]))
        
        @pages = MaiNavPages.new(site.pages, current_page)

        if @pages.by_category(current_page["category"]).length != 0 && @@t == ""

            @@t = "Running first type"
            print "\t\t#{@@t}\n"

          items = render_menu(@pages.by_category(current_page["category"]))
        end


        return %( Refurbishing code: <ul class="#{(@classnames || "")}">#{items}</ul> )

      end
   


      private 

        #
        # Render menu
        # 
        # Recursively parse the pages tree and 
        # generate nested HTML lists.
        #
        def render_menu(pages)

          # Find the deepest level 
          level_range = @pages.deepest_level..0

          #
          # Loop aal page levels and find levels parent level page
          (level_range.first).downto(level_range.last).each{|i|

            MaiNavPages.by_level(pages, i).each{|page|
                # Find it's parent
                  page.parent = @pages.find_parent_for(page)
                  print page.url, "\n" 
              }

          }

          print "\n\n\t\t\t ***** \n\n"

          pages.each{|page|
            print "Page #{page.url}: #{ page.parent.url || "top_level"}\n --------------------------- \n"
          }


        end


    end

  end
end

# Register catnav tag
# 
Liquid::Template.register_tag( Jekyll::MaiNav::CatNavTag::TAG_NAME, Jekyll::MaiNav::CatNavTag)

