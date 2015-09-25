# Mainav

**NB!** - Readme needs updating, basic info given. Be noted that this project is still in it's early phase. This is my very first Ruby project.

Simple nesting navigation tag for Jekyll. 

## 

## Install

Copy the mainav.rb to your Jekyll sites _plugins directory. If the _plugins directory does not exist, create it.


## Usage

Place liquid tag `{% catnav %}` into your navigation area.

Now to make pages nestable, add each page you want in menu to same category by inserting `category: "mycat"` 
to each page's frontmatter and name your pages like this: `1-page, 1.1-some-subpage, 1.1.1-even-more-subpage ... etc`

No menu is generated when category is not set in frontmatter.

## Tag attributes

### category:
You can also use catnav tag as a table of contents generator by placing tag at the beginning of the page and use a parameter category: <category name> to generate navigation for specific category. By default current pages category is used. 
        
        {% catnav category: myothercat %}    

### class:
Class names for stylesheet.

        {% catnav class: "toc nav blue-box" %}    


## Todo:
 - [x] Create nested navigation out of pages in current category.
 - [x] Allow category to be set in tag to generate menu on other pages.
 - [ ] Add classes for CSS - current-menu-item, menu-item-has-children etc...
 - [ ] Make an option to modify id-delimiter(-) and id-level delimiter (.) to be set by _config.
 - [ ] Add an option to align and nest pages by frontmatter field so that filenames wouldn't have to be changed - `orde-by-fname`.
 - [ ] Add a tag to generate main navigation.
 - [ ] Add an option for `navigation: true/false` to include/exclude from main navigation. 
 - [ ] Add nesting depth limit attribute for tag.
 - [ ] Multible categories to enable multible categories menu - good for e.g table of contents.
 - [ ] Add option to generate menu for specific page. For example `page: 'my-animals.md'`
 


 