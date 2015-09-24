#
# Mainav - simple nesting navigation menu tag for Jekyll
# 
# Mainav enables you to create navigation menus for pages and 
# even have them nesting.
#
# @author Aksel Meola <aksel@meola.eu>
# @version 0.1
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
 
  class PageNavigationTag < Liquid::Tag

  	#
  	# Page delimiter
  	#
  	@@delimiter = "."
  	@@id_delimiter = "-"

    #
    # Initilize class
    #
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end
 
    #
    # Render naviation menu
    #
    def render(context)

      site = context.registers[:site]

      current_page = context.registers[:page]
      pages = pages_with_category(site.pages, current_page["category"])
      
			if pages.length != 0
				items = render_menu(pages, pages.select{|page| page_id_length( page ) == 1 } )
			end
	    

      %( <ul class="#{@text}">#{items}</ul> )

    end
 


    private 

	    #
	    # Get pages that are in the same category as the current page
	    #
	    # TODO: Make it search in categories also
	    def pages_with_category(pages, category)
	      pages.select { |page|
	        !page.data["category"].nil? && page.data["category"] == category }
	    end

	    #
	    # Get pages's ID part
	    #
	    def get_page_id(page)
	    	page.path.split("/").last.split(@@id_delimiter).first
	    end

	    #
	    # Get how many levels in page id
	    #
			def page_id_length(page_id)
				get_page_id(page_id).split(@@delimiter).length
			end

			def group_of(page_id)
				 get_page_id(page_id).split(@@delimiter).first
			end

			def get_subitems(page_ids, cur_id)
				subitems = page_ids.select{|id| 
					group_of(id) == group_of(cur_id) and page_id_length(id) == page_id_length(cur_id)+1 and ( get_page_id(id).casecmp get_page_id(cur_id) )>0 }		
			end


			#
			# Render menu
			#
			def render_menu(pages, page_ids)

				output = ""

				for i in 0..page_ids.length-1

					subitems = get_subitems(pages, page_ids[i] );

					if subitems.length == 0 
						o <<  %(<li><a href="#{page_ids[i].url}">#{page_ids[i].data["title"]}</a></li> )

					else
						o << %(
							<li>
							<a href="#{page_ids[i].url}">#{page_ids[i].data["title"]}</a> 
								<ul>
									#{ render_menu(pages, subitems) }
								</ul>
							</li> )
					end

				end

				return o

			end
	 


  end
end
 
Liquid::Template.register_tag('page_navigation', Jekyll::PageNavigationTag)

