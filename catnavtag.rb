#  __  __  ____  _ __  _  ______  __
# |  \/  |/ () \| |  \| |/ () \ \/ /
# |_|\/|_/__/\__\_|_|\__/__/\__\__/
#         Mainav - navigation for Jekyll
#
#
# @author Aksel Meola <aksel@meola.eu>
# @author Ekkart Kleinod <ekleinod@edgesoft.de>
# @version 0.3
# @start_date 24.09.15
#
# @license: One of those it's free and don't sue licences.

# main module for all code
module MaiNav

	# class for catnav tag
	class CatNavTag < Liquid::Tag

		TAG_NAME = 'catnav'

		#
		# Holds all the valid pages for each rendering.
		# Should save some time on each run
		@@pages   = nil
		@@categories = [];

		def initialize(tag_name, args, tokens)
			#
			#
			#
				super

				@classnames = nil
				@categories = nil
				@depth      = nil
				@id         = nil


				# Scan for tag arguments
				#
				args.scan(Liquid::TagAttributes) do |key, value|
					#
					# Id for UL element
					if key == "id"
						@id = value.tr("\"'", "")
					end
					#
					# Classes for styling UL element
					if key == "classes"
						@classnames = value.tr("\"'", "")
					end
					#
					# Navigation depth
					if key == "depth"
						@depth = value.tr("\"'", "").to_i
					end
					#
					# Category to generate navigation for
					# Multible categories are allowed
					if key == "categories"
						@categories = value.tr("\"'", "").split(" ")
					end

				end

		end


		def render(context)

			out = ""

			#
			# TODO: Review this methods code.
			#
			# Check if pages have already been fetched and save some time on each rendering.
			if @@pages.nil?
				site = context.registers[:site]
				#
				# get valid pages for navigation
				@@pages = site.pages.select{|page|
					(page.html? || page.index?) && (page.[]('hide-nav') != true)
				}
				#
				# Get all available categories
				# TODO: This is very inefficent piece of monkey doodoo
				@@pages.each{|page|
						@@categories += page.categories
				}
				@@categories.uniq!

				testpage = site.pages[0]
				out << %(<p>#{testpage.[]('hide-nav') || "---"}</p>)
				out << %(<p>#{@@pages || "---"}</p>)

			end

			#
			# Current page for rendering current item class
			# and current pages's category
			cp = context.registers[:page]
			# Get current pages's Page object
			@cp = @@pages.select {|page|
				page.path == cp["path"]
			}.first

			#
			# If category is not specified
			pages = []
			if @categories.nil?
				pages = Utils::pages_by_categories( @@pages , @cp.categories);
			else
				# Get pages in given category/categories
				if @categories.include?("*")
					# All categories selected
					pages = Utils::pages_by_categories( @@pages , @@categories);
				else
					# Some categories selected
					pages = Utils::pages_by_categories( @@pages , @categories);
				end
			end

			#
			# Check if pages found ?
			#
			if pages.length == 0
				return ""
			end


			#
			# Find the top level pages to start generating the HTML
			#
			# For the time being we assume all top level pages have their parent as nil.
			#
			# NOTE: Page parent is probaly not nil when generating for subpath.
			top_level_pages = pages.select{|page|
				page.parent.nil?
			}

			items, ancestor = render_html(top_level_pages, pages, 0)

			out << %(<ul id="#{@id || "" }" class="#{@classnames || "" }">
					#{items} </ul>)

			%(#{out})

		end

		def render_html( cur_level, pages, depth )
			#
			# TODO: Document and review this.
			#
			html = ""
			ancestor = false

			#
			# Check if depth limit is set and have we met it ?
			#
			if !@depth.nil? && depth >= @depth
				return html, ancestor
			end

			#
			# If IGNORE_LEVEL is set to true then we assume that level
			# attribute is used for aligning items only.
			#
			# So ve sort the current set of pages by pages level attribute.
			if MaiNav::IGNORE_LEVEL == true
				cur_level.sort!{|a,b|
					a.data["level"].to_s <=> b.data["level"].to_s }
			end

			#
			# Loop over all pages and render HTML markup.
			cur_level.each{|page|
				#
				# Get current pages's children
				subhtml, subancestor = render_html(
						pages.select{ |spage|
							spage.parent == page
						},
						pages,
						depth + 1
					)

				#
				# Find CSS classes for current item
				classes = []
				if @cp.url == page.url
					ancestor = true
					classes << "current-item"
				elsif subancestor == true
					ancestor = true
					classes << "current-item-ancestor"
				end

				if subhtml.length > 0
					classes << "item-has-children"
					subhtml = %(<ul>#{subhtml}</ul>)
				end

				#
				# Render the LI element
				html << %(<li class="#{classes.join(" ")}" >
							<a href="#{page.url}">#{page.data["navtitle"] || page.data["title"]}</a>
							#{subhtml}
							</li> )
			}
			return html, ancestor # That's really neat thing about Ruby!
		end


	end

end
