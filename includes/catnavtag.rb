module MaiNav
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

    if @pages.by_category(current_page["category"]).length != 0  # && @@t == ""

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
        print "Page #{page.name}: #{ !page.parent.nil? && page.parent.name }\n --------------------------- \n"
      }


    end


end

end