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

        # Scan for tag arguments
        #
        # TODO: Implement all the attribute ideas.. 
        args.scan(Liquid::TagAttributes) do |key, value|  
          
          if key == "class"
            @classnames = value.tr("\"'", "");
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

      pages = site.pages.select{|page|
        page.mcategory == @cp["category"] && (page.html? || page.index?)
      }
      #
      # Find top level pages
      top_level = pages.first.data["level"].split(MaiNav::LEVEL_DELIMITER).length
 
      pages.each do |page|
        l = page.data["level"].split(MaiNav::LEVEL_DELIMITER).length
        if l < top_level
          top_level = l
        end
      end

      ptmp = []
      pages.each do |page|
        l = page.data["level"].split(MaiNav::LEVEL_DELIMITER).length
        if l == top_level
          ptmp << page
        end
      end

      items, ancestor = render_html( ptmp, pages )

      %(<ul> #{items} </ul>)
    end

    def render_html( cur_level, pages )
      #
      # TODO: Document and review this.
      #
      html = ""
      ancestor = false
      
      cur_level.each{|page|

        subhtml, subancestor = render_html(
            pages.select{ |spage|
              spage.parent == page
            },
            pages
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
              <a href="#{page.url}"> #{page.data["title"]} </a> 
              #{subhtml}
              </li> )
      }
      return html, ancestor # That's really neat thing about Ruby!
    end


  end

end
