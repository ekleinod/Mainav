module MaiNav

  class CatNavTag < Liquid::Tag

    TAG_NAME = 'catnav'

    def initialize(tag_name, args, tokens)
      #
      #
      #
        super

        @classnames = nil
        @category   = nil
				@all_categories = false
        @depth			= nil
        @id					= nil


        # Scan for tag arguments
        #
        # TODO: Implement all the attribute ideas.. 
        args.scan(Liquid::TagAttributes) do |key, value|  
          #
          # Id for UL element
          if key == "id"
            @id = value.tr("\"'", "")
          end
 					#
 					# Classes for styling UL element
          if key == "class"
            @classnames = value.tr("\"'", "")
          end
          #
          # Navigation depth  
          if key == "depth"
            @depth = value.tr("\"'", "").to_i
          end
          #
          # Category to generate navigation for
          # TODO: Create a loop to generate navigation for all of the categories if multible specified  
          if key == "category"
            @category = value.tr("\"'", "")
          end
          #
          # 
          if key == "all-categories"
            @all_categories = true
          end

        end

    end


    def render(context)
      #
      # TODO: Review this methods code.
      # NOTE: Using class or instance variables might be benefit for speed. 
      #
      site = context.registers[:site]
      @cp = context.registers[:page]

      if @category.nil?  && @all_categories == false
      # Get pages in current pages category 
      #
      # TODO: Write a method that check's current pages category 
      # Utils::set_category should do.. but not sure now..
      #
      	pages = []
      elsif @all_categories == true 
	    # Get all pages 
	      pages = site.pages.select{|page|
	      	page.html? || page.index?
	      }      	
      else
      # Get given category pages 	
	      pages = site.pages.select{|page|
	      	page.mcategory == @category
	      }
      end
      #
      # Check if pages found ?
      #
      if pages.length == 0
      	return ""
      end
      #
      #
      # Find top level pages
      top_level = pages.first.mlevel.split(MaiNav::LEVEL_DELIMITER).length
 			#
      #
      pages.each do |page|
        l = page.mlevel.split(MaiNav::LEVEL_DELIMITER).length
        if l < top_level
          top_level = l
        end
      end
      #
      #
      ptmp = []
      pages.each do |page|
        l = page.mlevel.split(MaiNav::LEVEL_DELIMITER).length
        if l == top_level
          ptmp << page
        end
      end
      #
      items, ancestor = render_html( ptmp, pages, 0 )

      %(<ul id="#{@id || "" }" class="#{@classnames || "" }"> 
      		#{items} </ul>)

    end

    def render_html( cur_level, pages, depth )
      #
      # TODO: Document and review this.
      #
      html = ""
      ancestor = false

      #
      # Check if depth limit is set and have we met it ?
      #
      if !@depth.nil? && depth >= @depth
      	return html, ancestor
      end

      #
      # If IGNORE_LEVEL is set to true then we assume that level 
      # attribute is used for aligning items only. 
      #
      # So ve sort the current set of pages by pages level attribute.
      if MaiNav::IGNORE_LEVEL == true
      	cur_level.sort!{|a,b| 
      		a.data["level"].to_s <=> b.data["level"].to_s }
      end	

      cur_level.each{|page|

        subhtml, subancestor = render_html(
            pages.select{ |spage|
              spage.parent == page
            },
            pages,
            depth + 1
          )

        if @cp["url"] == page.url
          ancestor = true
          classes = "current-item"
        elsif subancestor == true
          ancestor = true
          classes = "current-item-ancestor"
        else
          classes = ""              
        end

        if subhtml.length > 0
          classes << " item-has-children"
          subhtml = %(<ul>#{subhtml}</ul>)
        end

        html << %(<li class="#{classes}" >
              <a href="#{page.url}"> #{page.data["navtitle"] || page.data["title"]} </a> 
              #{subhtml}
              </li> )
      }
      return html, ancestor # That's really neat thing about Ruby!
    end


  end

end
