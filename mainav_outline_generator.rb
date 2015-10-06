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
            MaiNav::Utils.set_categories(page)
            #
            # Find page level
            MaiNav::Utils.set_level(page) 
        }
        # Sort list by level attribute now.
        # NOTE: This sorts the whole site.pages array.
        # TODO: See why set_parent only works correctly on sorted array.
        #
        site.pages.sort!{|a,b| a.mlevel.to_s <=> b.mlevel.to_s } # TODO: see if to_s is still necessary
        #
        # Assign a parent for each page item  
        site.pages.each{|page|          
          MaiNav::Utils.set_parent(site.pages, page)  
         }        

      end
  end

end 

