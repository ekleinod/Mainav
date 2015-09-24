# Mainav

**NB!** - Readme needs updating, basic info given. Be noted that this project is still in it's early phase.

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




