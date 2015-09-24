# Mainav

**NB!** - Readme needs updating, basic info given. Be noted that this project is still in it's early phase.

Simple nesting navigation tag for Jekyll. 

## 

## Install

Copy the mainav.rb to your Jekyll sites _plugins directory. If the _plugins directory does not exist, create it.


## Usage

PLace liquid tag `{% page_navigation navclass %}` into your navigation area.

Now to make pages nestable, add each page you want in menu to same category by inserting `category: "mycat"` 
to each page's frontmatter and name your pages like this: `1-page, 1.1-some-subpage, 1.1.1-even-more-subpage ... etc`

