#
# MaiNav Jekyll Page patch
#
# Adds few functionalities to Page class
#
#
module Jekyll

  class Page    
    
    #
    # Holds link to page's parent page.
    #
    attr_reader :parent, :categories, :mlevel
    attr_writer :parent, :categories, :mlevel


    def in_category?(category)
      # Find out if page belongs into given category.
      # NOTE: mcategory is used for categories. 
      #
      # @param  - Category to check against.
      # @returns  - Boolean true/false
      #
      self.categories.each do |selfcat|
      	if selfcat == category
      		return true
      	end	
      end
      return false
    end


  end
   
end