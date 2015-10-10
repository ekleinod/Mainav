#
# MaiNav Jekyll Page patch
#
# Adds few functionalities to Page class
#
#
module Jekyll

  class Page    
  	#
  	# page  - Page's parent page.
  	# categories - Array of categories the page belongs to.
  	# mlevel - Determines pages hierarchy. 
  	#
    attr_reader :parent, :categories, :mlevel
    attr_writer :parent, :categories, :mlevel
  end
   
end