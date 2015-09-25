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
    attr_reader :dir
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
    @@delimiter = "."
    @@id_delimiter = "-"

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
      
      pages = pages_with_category(site.pages, (@category || current_page["category"]))
      
      if pages.length != 0
        items = render_menu(pages, pages.select{|page| page_id_length( page ) == 1 } )
      end

      return %( Refurbishing code: <ul class="#{(@classnames || "")}">#{items}</ul> )

    end
 


    private 

      #
      # Get pages that are in the same category as the current page
      #
      # TODO: Make it search in categories also
      def pages_with_category(pages, category)
        return pages.select { |page|
          !page.data["category"].nil? && page.data["category"] == category }
      end

      #
      # Get pages's ID part
      #
      def get_page_id(page)
        return page.path.split("/").last.split(@@id_delimiter).first
      end

      #
      # Get how many levels in page id
      #
      def page_id_length(page)
        return get_page_id(page).split(@@delimiter).length
      end

      #
      # Get the first part of the page id
      #
      def group_of(page)
         return get_page_id(page).split(@@delimiter).first
      end

      # 
      # Get all pages that are a direct subpages of the current page.
      #
      # Page is a subpage if:
      #  * Starts's with a same level/group number
      #  * Has more levels in it's id
      #  * ID is alphabetically after current page
      # 
      def get_subitems(pages, cur_page)
        
        return pages.select{|page| 
          group_of(page) == group_of(cur_page) and
          page_id_length(page) == page_id_length(cur_page) + 1 and
          ( get_page_id(page).casecmp get_page_id(cur_page) ) > 0 
        }   

      end


      #
      # Render menu
      # 
      # Recursively parse the pages tree and 
      # generate nested HTML lists.
      #
      def render_menu(pages, cur_pages)

        html = ""

        for i in 0..cur_pages.length-1

          subpages = get_subitems(pages, cur_pages[i] );

          if subpages.length == 0 
            html <<  %(<li><a href="#{cur_pages[i].url}">#{cur_pages[i].data["title"]}</a></li> )
          else
            html << %(
              <li>
              <a href="#{cur_pages[i].url}">#{cur_pages[i].data["title"]}</a> 
                <ul>
                  #{ render_menu(pages, subpages) }
                </ul>
              </li> )
          end

        end

        return html

      end
   


  end

end

# Register catnav tag
# 
Liquid::Template.register_tag( Jekyll::CatNavTag::TAG_NAME, Jekyll::CatNavTag)

