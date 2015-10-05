# Mainav - code refurbish

**NB!** - Be noted that this project is still in it's early phase.

Purpose: All your navigation needs in Jekyll!

## Features TODO:

 - [x] Nested lists based on category.
 - [ ] Nested lists per multible categories
 - [ ] Nested list based on path
 - [x] Nested list based on path structure.
 - [x] Classnames for current page, ancestors, has-children. 
 - [x] Generating depth support
 - [ ] Table of contents per page
 - [ ] Configuration file options support 
 - [ ] Breadcrums support
 - [ ] Option for breadcrums to set parent elements(HOME) inclusin or title.
 - [ ] Option to ignore top element (Maybe useful?)
 - [ ] Field for navigation title
 - [ ] Support for post archive navigations
 - [ ] Next, previous and parent page link tags. 
 - [ ] Option to make list items with sub items not display as links(for accordion menus).
 



## Install

Copy all `.rb` files to your Jekyll site's `_plugins` directory. If directory does not exist, create it.

## Usage

### What is level ?

Level is the way MaiNav decides how the pages should be aligned and nested. 
Level can be defined by different ways: 
(**In future that can be set in _config.yml - right now MaiNav checks for level attribute in frontmatter, then file name and then uses page path.**)
 
 - By `level` attribute in pages frontmatter:

```

    ---
    title: Animals
    level: 1
    ---

```
Subpages then should have the levels 1.1, 1.2 etc. Subpages to level 1.1 should go 1.1.1, 1.1.2 and so on. Levels should be separated by dot by default. In future the level delimiter character can be set in _config.yml file.

You could also use words or letters as levels: animal, animal.dog, animal.cat.
Be noted that level also decides the order of pages in navigation (so animal.cat comes before animal.dog).

 - By file name: 

``` 
    
    1-animals.md, 1.1-dog.md, 1.2-cat.md, ... 

```
Levels have to be separated by level delimiter character( . is default ) and separated from file name by level separator character( - is default ). 
In future these can be changed in _config.yml file. Letters and words can also be used as levels. 

If you set level separator to dot then file names like animals.dog.md, animals.cat.md would still work. Order of pages is decided by page levels.

 - By file path:
Since pretty permalinks are usually preferred this taks the least effort. 
Reordering in navigation can be just done by relocating the directories. 

```

      animals/  
      animals/dog
      animals/cat
```
Optionally pages in same directory can be ordered by setting the level attribute in pages's frontmatter - this can be just 1, 2, 3, 4 etc..
**Currently this is done by default.**


### Page attributes

 - level - Page nesting level attribute. If level attribute is ignored or unset then nesting is based on destination directory path. If `ignore_level` option is set true level is used to align pages in specific order. 
 - category/categories - Category or categories for the page (Jekyll stuff)
 - navtitle - When set this is shown as a link title in navigation.

### Liquid tag: catnav

Example

    {% catnav %}

**Supported attributes:**
 
 - class: - Containing UL element class name/names. 
 - id: - ID for the UL element.
 - category: Category name to generate the navigation for. By default current page's category is used. 
 - depth: How many levels deep to generate the navigation. By default infinite depth is used. 
 


### Liquid tag: maicrums

    {% maicrums %}

Generates a UL element containing all pages to the current page. 

**Currently parent(HOME) page's title can't be set.**


### Liquid tag: maicontents

    {% maicontents %}

Generates a UL element containing all titles on the current page. 

**Not implemented**
