#	 __  __  ____  _ __  _  ______  __
#	|  \/  |/ () \| |  \| |/ () \ \/ /
#	|_|\/|_/__/\__\_|_|\__/__/\__\__/ 
# 				Mainav - navigation for Jekyll
#
#
# Tired of long liquid code for navigation ? 
# Mainav enables you to create navigation menus for pages and 
# even have them nesting. Navigation can be generated for 
# pages in specific category, for specific page and it's subpages
# or just for the page itself eg. to display table of contents.
#
# @author Aksel Meola <aksel@meola.eu>
# @version 0.1-refurbish
# @start_date 24.09.15
# @demo http://pascal.meola.eu uses it for it's navigation stuff.
#
# @licence: One of those it's free and don't sue licences. 
#


#
# Modifications to the Jekyll Page class
require_relative 'includes/page.rb'
#
# Mainav rendering engine
require_relative 'includes/mainavpage'
#
# Liquid "catnav" tag
require_relative 'includes/catnavtag.rb'  		
#
# Register catnav tag
Liquid::Template.register_tag( MaiNav::CatNavTag::TAG_NAME, MaiNav::CatNavTag)

#
# testing
=begin
#module Jekyll

	class CategoryPageGenerator < Generator
	    safe true

	    def generate(site)
	    	site.pages.each{|page|
	    			#page.data["permalink"] = "/karulaane-" + page.name.split(".").first
	    	}
	    end
	end

end

=end
