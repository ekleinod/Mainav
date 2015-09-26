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
  # Scan all pages starting from deepest level and working
  # one's way up to the top level and assigning each page
  # it's parent page.
  #
  # @param 	-	Set of pages to outline
  # 
  # TODO: Render outline for all pages and then just use the data on each call to save computing power.
  def render_outline(pages)

    # Find the deepest level 
    level_range = self.deepest_level_of(pages)..0
    # Sacan and assign parents
		(level_range.first).downto(level_range.last).each{|i|
      self.by_level(pages, i).each{|page|
      	# Find it's parent
        page.parent = @pages.find_parent_for(page) }
    }

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

    ##
    # Get deepest level in set of pages
    #
    # @param  - List of pages to search from
    #
    # @returns  - Deepest level
    #
    def MaiNavPages.deepest_level_of(pages)
 				deepest_level = 0

        @pages.each{|page|
          if page.level > deepest_level
            deepest_level = page.level
          end  
        }        
       @deepest_level
    end

end

end
