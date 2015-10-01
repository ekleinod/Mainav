#
#
#
#
#
#
module Jekyll

  class MaiNavOutlineGenerator < Generator
      safe true

      def generate(site)
        site.pages.each{|page| 
            # 
            # Find page category           
            MaiNav::Utils.set_category(page) 
            #
            # Find page level
            MaiNav::Utils.set_level(page) 
        }
        # Sort list by level attribute now.
        # NOTE: This sorts the whole site.pages array.
        # TODO: See why set_parent only works correctly on sorted array.
        #
        site.pages.sort!{|a,b| a.data["level"].to_s <=> b.data["level"].to_s }
        #
        # Assign a parent for each page item  
        site.pages.each{|page|          
          MaiNav::Utils.set_parent(site.pages, page)  
         }        

      end
  end

end 

