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
    attr_reader :parent, :mcategory, :mlevel
    attr_writer :parent, :mcategory, :mlevel

    def in_category?(category)
      # Find out if page belongs into certain category.
      #
      # @param  - Page whose categories to search from.
      # @param  - Category to check against.
      # @returns  - Boolean true/false
      #
      if !self.data["category"].nil?
        return category == self.data["category"]
      
      elsif !self.data["categories"].nil?
        # Are categories feed to me as array 
        if self.data["categories"].kind_of?(Array) 
          cats = self.data["categories"]
        else
          cats = self.data["categories"].split(" ")          
        end  
        cats.each do |cat|
          if cat == category 
            return true
          end  
        end
        return false         
      
      else
        # No category is specified 
        # TODO: Check if the parent directory thingy is feasible.
        #
        false
      end 

    end


  end
   
end