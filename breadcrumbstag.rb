module MaiNav

	class BreadCrumbsTag < Liquid::Tag

    TAG_NAME = 'breadcrumbs'

    def initialize(tag_name, args, tokens)
      #
      #
      #
        super

        @classnames = nil
        @id   			= nil
        @home				= nil

        # Scan for tag arguments
        args.scan(Liquid::TagAttributes) do |key, value|  
          #
          # Id for UL element
          if key == "id"
            @id = value.tr("\"'", "")
          end
          #
          # Classes for styling UL element
          if key == "classes"
            @classnames = value.tr("\"'", "")
          end
          #
          # Title of the home element
          if key == "home"
            @home = value.tr("\"'", "")
          end

        end

    end


    def render(context)
      #
      #
      #
      site = context.registers[:site]
      #
      # Current page 
      cp = context.registers[:page]
      # Get current pages's Page object
     	@cp = site.pages.select {|page|  
     		page.path == cp["path"]
     	}.first  

     	#
     	# Loop until reached to the top page.
     	#
      items = []
      p = @cp
      if @cp.parent.nil?
      	# We are on the top page.
      	# TODO: Reliable checks needed
      	if @cp.url != "/index.html"
      		items << %(<li>#{p.data["title"]}</li>)
      	end
      else
      	items << %(<li>#{p.data["title"]}</li>)
      	while !p.parent.nil?
      		p = p.parent
      		items << %(<li><a href="#{p.url}">#{p.data["navtitle"] || p.data["title"]}</a></li>) 
      	end
      end

    	#
    	# Add the HOME element. 
    	# If Home is not set use the index page's title.
    	if @home.nil?
    		indexpage = site.pages.select{|page|
    			# TODO: Reliable checks needed
    			page.url == "/index.html"
    			}.first
    			items << %(<li><a href="#{site.config["url"]}">#{indexpage.nil? ? "Home" : indexpage.data["title"]}</a></li>)
     	else
    		items << %(<li><a href="#{site.config["url"]}">#{@home}</a></li>)
    	end

      #
      # If items more than home element then output the UL element
      if items.length > 1
      	%(<ul id="#{@id || ""}" class="#{@classnames || ""}">#{ items.reverse().join("") }</ul>)
      else
      	%()
      end
    end





  end

end
