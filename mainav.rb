#  __  __  ____  _ __  _  ______  __
# |  \/  |/ () \| |  \| |/ () \ \/ /
# |_|\/|_/__/\__\_|_|\__/__/\__\__/
#         Mainav - navigation for Jekyll
#
#
# Tired of long liquid code for navigation ?
# Mainav enables you to create navigation menus for pages and
# even have them nesting. Navigation can be generated for
# pages in specific category, for specific page and it's subpages
# or just for the page itself eg. to display table of contents.
#
#
# @author Aksel Meola <aksel@meola.eu>
# @author Ekkart Kleinod <ekleinod@edgesoft.de>
# @version 0.2
# @start_date 24.09.15
# @demo http://pascal.meola.eu uses it for it's navigation stuff.
#
# @license: One of those it's free and don't sue licences.

# Include needed files
require_relative 'breadcrumbstag.rb'
require_relative 'catnavtag.rb'

# Register catnav tag
Liquid::Template.register_tag( MaiNav::CatNavTag::TAG_NAME, MaiNav::CatNavTag)
Liquid::Template.register_tag( MaiNav::BreadCrumbsTag::TAG_NAME, MaiNav::BreadCrumbsTag)

# main module for all code
module MaiNav

	LEVEL_DELIMITER = "." # NOTE: Level delimiter constant

	#
	# Ignore level attribute in pages and use
	# it just for aligning same level pages.
	IGNORE_LEVEL    = true # NOTE: Ignore level set to true

	#
	# Utility functions for various stuff
	#
	class Utils

		def self.page_categories(page)
			# Return the categories set in category or categories
			# frontmatter of the page.
			#
			# @returns - Array of categories
			#
			categories = []
			# Is category set ?
			if page.data["category"].nil?
				# Is categories set then ?
				if !page.data["categories"].nil?
					# Ok, is it array or string ?
					if page.data["categories"].kind_of?(Array)
						# Just get the array
						categories = page.data["categories"]
					else
						# Trim string for quotes and split by spaces.
						categories = page.data["categories"].tr("\"'", "").split(" ")
					end
				end
			else
				categories << page.data["category"]
			end
			return categories
		end

		def self.pages_by_categories(pages, categories)
			# Get pages by given  categories.
			# NOTE: categories array is used for categories.
			#
			# @param -  Pages to select from.
			# @param -  Category whose pages to get.
			#
			# @returns -  Array of pages in given categories.
			#
			pages.select{|page|
				# Check if any of the elements in both arrys match
				# Another cool Ruby trick.
				!(page.categories & categories).empty?
			}
		end

		def self.set_level(page)
			#
			# Set pages mlevel attribute
			#
			#
			# Is level atribute set
			if MaiNav::IGNORE_LEVEL == true || page.data["level"].nil?
				# Make levels out of directory structure
				page.mlevel = page.dir.split("/").drop(1).join(LEVEL_DELIMITER)
				#page.mlevel = "top" + page.dir.split("/").join(LEVEL_DELIMITER)
			else
				#
				# Convert to string incase 1.1, 1.2 ... are detected as a float.
				page.mlevel = page.data["level"].to_s
			end
		end


		def self.set_categories(page)
			# Set the pages patched categories attribute based on category or categories
			# frontmatter. If those are not set then use a destination directories base
			# dir as a category.
			#
			# @param -  Page whose categories attribute is to be set.
			#
			page.categories = self.page_categories(page)
			#
			# No categories set - use destination directory's base as a category.
			if page.categories.length == 0
				page.categories << page.dir.split("/").at(1) || "nil" #NOTE: nil signifies a top level page
			end
		end


		def self.set_parent(pages, page)
			#
			# Try to find and set page's parent
			page.parent = nil
			#
			# Work only on html and index pages
			if !page.html? && !page.index?
				return false
			end
			#
			# Check if page is allready on top level
			if page.mlevel.split(LEVEL_DELIMITER).length > 1
				#
				# No - get upper level page
				levels = page.mlevel.split(LEVEL_DELIMITER)
				upper_level = levels.take(levels.length - 1).join(LEVEL_DELIMITER)
				#
				# Now find a page in same category and has this upperlevel as a level
				pages.each do |p|
					# TODO: Cleanup. See if .to_s is still necessary. This should be dealth with in set_level() method.
					if p.mlevel.to_s == upper_level.to_s && !(p.categories & page.categories ).empty?
						page.parent = p
						return true
					end
				end
			end

		end

	end

end

