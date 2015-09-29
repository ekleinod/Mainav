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
            #
            # Find page parent
            #MaiNav::Utils.set_parent(site.pages, page)  

            
            #if page.parent.nil?
              #page.data["soor"] = ":<b>#{page.data["level"]}</b>  #{page.path}" 
            #end
              

            # test  
            #if page.parent.nil?
            #  page.data["soor"] = "#{page.data["level"]} #{page.name}" 
            
            #else
            #  page.data["soor"] = "#{page.data["level"]} (#{ page.parent.data["level"]})" 

            #end
        }

        # (Sorting works )
        site.pages.sort!{|a,b| a.data["level"].to_s <=> b.data["level"].to_s }

        site.pages.each{|page|
          
          MaiNav::Utils.set_parent(site.pages, page)  

          if page.html? or page.index?
            if page.parent.nil?
              page.data["soor"] = "#{page.data["level"]} #{page.name}" 
              
            else
                page.data["soor"] = "#{page.data["level"]} (#{ page.parent.data["level"]}) " 

            end
          end
         }        

      end
  end

end 

