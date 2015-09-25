#
# Mainav - simple nesting navigation for Jekyll
# 
# Mainav enables you to create navigation menus for pages and 
# even have them nesting. 
#
# @author Aksel Meola <aksel@meola.eu>
# @version 0.1-refurbish
# @date 24.09.15
#
# @licence: One of those it's free and don't sue licences. 
#
# 


#
# Modifications to the Jekyll Page class
require_relative 'includes/page'
#
# Mainav rendering engine
require_relative 'includes/mainavpage'
#
# Liquid "catnav" tag
require_relative 'includes/catnavtag.rb'  		
#
# Register catnav tag
Liquid::Template.register_tag( MaiNav::CatNavTag::TAG_NAME, MaiNav::CatNavTag)

