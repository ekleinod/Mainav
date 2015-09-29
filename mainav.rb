#  __  __  ____  _ __  _  ______  __
# |  \/  |/ () \| |  \| |/ () \ \/ /
# |_|\/|_/__/\__\_|_|\__/__/\__\__/ 
#         Mainav - navigation for Jekyll
#
#
# Tired of long liquid code for navigation ? 
# Mainav enables you to create navigation menus for pages and 
# even have them nesting. Navigation can be generated for 
# pages in specific category, for specific page and it's subpages
# or just for the page itself eg. to display table of contents.
#
#
# @author Aksel Meola <aksel@meola.eu>
# @version 0.1-refurbish
# @start_date 24.09.15
# @demo http://pascal.meola.eu uses it for it's navigation stuff.
#
# @licence: One of those it's free and don't sue licences. 
#
=begin
  TODO: (LIST)

  - [ ] Multilevel navigation by categories and paths
  - [ ] Breadcrums  

=end

#
# Modifications to the Jekyll Page class
#require_relative 'includes/page.rb'
#
# Mainav rendering engine
#require_relative 'includes/mainavpages'
#
# Liquid "catnav" tag
#require_relative 'includes/catnavtag.rb'     
#
# Register catnav tag
Liquid::Template.register_tag( MaiNav::CatNavTag::TAG_NAME, MaiNav::CatNavTag)
Liquid::Template.register_tag( MaiNav::MaiCrumsTag::TAG_NAME, MaiNav::MaiCrumsTag)

module MaiNav

  LEVEL_DELIMITER = "." # NOTE: Level delimiter constant
  LEVEL_SEPARATOR = "-" # NOTE: Level separator constant

  #
  # Utility functions for various stuff
  #
  class Utils

    def self.cats_match?(page1, page2)
      #
      # See if page 1 and page 2 share categories
      #

      if page1.mcategory.kind_of?(Array)
        cats1 = page1.mcategory
      else  
        cats1 = page1.mcategory.split(" ")
      end

      if page2.mcategory.kind_of?(Array)
        cats2 = page2.mcategory
      else  
        cats2 = page2.mcategory.split(" ")
      end
      
      cats1.each do |cat1|
        cats2.each do |cat2|
          if cat1 == cat2 
            return true
          end
        end
      end
      return false
    end


    def self.set_level(page)
      #
      # Set pages level attribute 
      #
      #

      # Is level atribute set 
      if page.data["level"].nil?
        # Is level pattern in file name ?
        if ( /^.+?[#{LEVEL_SEPARATOR}]/ =~ page.name ).nil?
          # Make levels out of directory structure
          page.data["level"] = page.dir.split("/").drop(1).join(LEVEL_DELIMITER)
        else
          page.data["level"] = page.name.split(LEVEL_SEPARATOR).first
        end  
      else
        #
        # Convert to string incase 1.1, 1.2 ... detected as a float.
        page.data["level"] = page.data["level"].to_s 
      end  
    end


    def self.set_category(page)
      # NOTE: (LIST)
      # Categories must be checked first in pages CATEGORY or CATEGORIES attribute
      # and then fall back to the directory structure where directory's name becomes 
      # the category. Some investigation has to be done before we can go with that route
      # safely. 
      #
      # First idea comes into mind to use the first directory in path as a category so that
      # all subdirectories would automatically fall into same category. That might be a wrong
      # assumption.
      #
      # Here's a first implementation for CATEGORY
      # TODO: Make it search in categories also
      #
      # Has Category been set ?
      if page.data["category"].nil?
        # Do categories exist perhaps ?
        if page.data["categories"].nil?
          page.mcategory = page.dir.split("/").at(1) || page.dir.split("/").first
        else
          page.mcategory = page.data["categories"]
        end
      else
        page.mcategory = page.data["category"]  
      end  
    end


    def self.set_parent(pages, page)
      #
      # Try to find and set page's parent
      page.parent = nil
      #
      # Work only on html and index pages 
      if !page.html? && !page.index? 
        return false
      end
      #
      # 1. Check if page is allready on top level
      if page.data["level"].split(LEVEL_DELIMITER).length > 1
        #
        # 2. Get upper level page
        levels = page.data["level"].split(LEVEL_DELIMITER)
        upper_level = levels.take(levels.length - 1).join(LEVEL_DELIMITER)
        #
        # Now find a page that has this upperlevel as a level
        pages.each do |p|    
          if p.data["level"].to_s == upper_level.to_s && self.cats_match?(p, page) # TODO: Check if categories match
            page.parent = p
            break
          end
        end
      end 

    end


    def self.level?(page)
      #
      # Check if level is set on page. 
      #
      # @param  - Page to check
      #
      # @returns  -  True if LEVEL attribute is set or filename has level pattern.
      #

      # Check for level pattern in file name 
      if ( pattern = /^.+?[#{ID_SEPARATOR}]/ =~ page.name ).nil?
        # Is a level attribute set
        if page.data["level"].nil?
          #
          # TODO: What else can we take into account as a level - directory perhaps ?
          #
          return false
        else
          return true
        end

      else
        return true
      end  

    end

    # TODO: rename to "id_for(page)" or "level_for(page)"
    def self.get_page_id(page)
      if page.index?
        # NOTE: (LIST)
        # Index pages occour when their basename is index. 
        # That usually means that they are used in pretty permalink
        # structures. That may very well be true all the time.
        # Here we mostly have to assume their relationships with parent pages 
        # by their directory path. This has to be calculated using the dir property of 
        # pages, because this is their final destination after all. Do not consider path.
        # Their parents name comes from parent page's TITLE attribute. 
        # Directory paths seem to be always the no.1 identifier of parent-child relations, 
        # but LEVEL attribute and category should override it.
        #
        # TODO: See if pretty permalinks are used.
        # 
        pattern = /^.+?[#{ID_SEPARATOR}]/

        (pattern =~ page.name).nil?.to_s + " #{page.name}"
      elsif page.html?
        # NOTE: (LIST) 
        # Html pages don't use pretty urls so that means that
        # there must be other way to find parent-children relations
        # between them. For exsample the LEVEL attribute or file name pattern "1.2-name". 
        # When pattern is not detected we must assume they are top level pages probably(1).
        # Also note that html pages can be nested in subdirectories so calculating the 
        # relationships comes more difficult for pages who have LEVEL patterns.
        # First of all we have to assume that pages parent is it's upper directory and
        # then use the LEVEL attribute or pattern if existing.
        #
        # TODO: 1. Make sure the assumption for being top level page is solid.
        #
        #
        pattern = /^.+?[#{ID_SEPARATOR}]/

        #(pattern =~ page.name).nil?.to_s + " #{page.name}"
        page.name.match(pattern).to_s + " #{page.name}"

     else
        # NOTE: (LIST) 
        # These pages are not content pages and in that case not be considered
        # for navigation structure. 
        # These are text files with some frontmatter declared - .scss, .txt etc..
        # We assume that these files are documents that are linked from pages's content etc..
        #
        #
        "#{page.dir} - Something else"
      end
      
    end



    def self.suggest_parent_for(page)
      #if page.level > 1
      #  page.levels.take(page.level-1).join(".") # NOTE: level separator
      #else
      #  "top_level"
      #end
    end

  end

end

