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


  end
   
end