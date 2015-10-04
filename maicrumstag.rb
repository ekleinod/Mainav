module MaiNav

	class MaiCrumsTag < Liquid::Tag

    TAG_NAME = 'maicrums'

    def initialize(tag_name, args, tokens)
      #
      #
      #
        super

        @classnames = nil
        @toplevel   = false

        # Scan for tag arguments
        args.scan(Liquid::TagAttributes) do |key, value|  
          
          if key == "class"
            @classnames = value.tr("\"'", "");
          end

          if key == "toplevel" 
          	if value == "false"
            	@toplevel = false
            else
            	@toplevel = true
            end	
          end
            

        end

    end


    def render(context)
      #
      #
      #
      site = context.registers[:site]
      cp = context.registers[:page]
      current = nil
      #
      # Find current page
      site.pages.each do |page|
      	if page.url == cp["url"]
      		current = page
      	end
      end

      items = []

      if !current.parent.nil?
      	p = current
      	items << %(<li>#{p.data["title"]}</li>)
      	while !p.parent.nil?
      		p = p.parent
      		items << %(<li><a href="#{p.url}">#{p.data["title"]}</a></li>) 
      	end
      end

      # TODO: Fifure out the right url and a link text
      if @toplevel == true
      	items << %(<li><a href="/">Index</a></li>)
    	end
      
      %(<ul class="#{@classnames || ""}">#{ items.reverse().join("") }</ul>)

    end





  end

end
