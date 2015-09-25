module MaiNav

#
# Object to hold information about a node in a page
#
class MaiNavPages
  
  attr_reader :current, :pages
  attr_writer :current

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

end
