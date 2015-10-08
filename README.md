# MaiNav - code refurbish

MaiNav is a plugin that tries to figure out pages relations to each other and assigns each page it's parent page etc.. With that information(hopefully right) it can then generate navigation menus, bread crumbs, links to next and previous pages ans so on. 

**NB!** - Be noted that this project is still in it's early phase.

Purpose: All your navigation needs in Jekyll!

## Features TODO:

 - [x] Nested lists based on category (_categories:"cat-name"_).
 - [x] Nested lists per multiple categories (_categories:"cat-1 cat-2"_).
 - [x] Nested list based on current pages's category.
 - [x] Nested list for all site's pages (_categories:*_).
 - [ ] Nested list based on given path.
 - [x] Nested list based on path structure.
 - [x] Nesting depth limiting attribute (_depth:2_).
 - [x] Class names for current page, ancestors, has-children. 
 - [ ] Table of contents per page
 - [ ] Configuration file options support 
 - [x] Bread crumbs support(_breadcrumbs_).
 - [x] Option for bread crumbs to set parent elements(HOME) inclusion or title(_home: attribute for title_).
 - [ ] ~~Option to ignore top element (Maybe useful?)~~
 - [x] Field for navigation title(_navtitle:_).
 - [ ] Support for post archive navigations
 - [ ] Next, previous and parent page link tags. 
 
 ---

 - [ ] Option to make list items with sub items not display as links(for accordion menus. This would look nicer too if CSS is disabled. ).
 
## Future changes

 - [x] Probably the file name pattern is up for exclusion, because it seems to have no good usage over folder structure and `level` attribute. It also ends up in final page's names and making a mechanism to exclude the level from final file path seems too much overhead for such a whiny little feature. The product of over thinking I guess.

 - [ ] Tag name `catnav` needs to be changed to something in line of it's purpose. Candidates `pagenav`. 


## Install

Copy all `.rb` files to your Jekyll site's `_plugins` directory. If directory does not exist, create it. 

I suggest you make a separate sub directory for all plugin's files. If you `git clone` to `_plugins` directory this is already taken care of.   

## Usage

### What is level ?

Level is the way MaiNav decides how the pages should be aligned and nested. 
Level can be defined by different ways: 
(**In future that can be set in _config.yml - right now MaiNav checks for level attribute in front matter and falls back using page's path.**)
 
 - By `level` attribute in pages front matter:

```

    ---
    title: Animals
    level: 1
    ---

```
Sub pages then should have the levels 1.1, 1.2 etc. Sub pages to level 1.1 should go 1.1.1, 1.1.2 and so on. Levels should be separated by dot by default. In future the level delimiter character can be set in _config.yml file.

You could also use words or letters as levels: animal, animal.dog, animal.cat.
Be noted that level also decides the order of pages in navigation (so animal.cat comes before animal.dog).


 - By file path:
Since pretty permalinks are usually preferred, implementing this takes the least effort. 
Reordering in navigation can be just done by relocating the directories. 

(**At current stage of the project - for debugging purposes this is set as the only option.**)

```

      animals/  
      animals/dog
      animals/cat
```
Optionally pages in same directory can be ordered by setting the level attribute in page's front matter - this can be just 1, 2, 3, 4 etc..
**Currently this is done by default.**


### Page front matter attributes

 - **level** - Page nesting level attribute. If level attribute is ignored or unset then nesting is based on destination directory path. If `ignore_level` option is set true level is used to align pages in specific order. 
 - **category** / **categories** - Category or categories for the page (Jekyll stuff)
 - **navtitle** - When set this is shown as a link title in navigation.

### Liquid tag: catnav
(_This tag's name is likely to be changed in the future._)

Example

    {% catnav %}

**Supported attributes:**
 
 - **classes** - Wrapping UL element's `class` attribute. Multiple classes can be specified by wrapping them into double quotes and separating with spaces.

```        

    {% catnav classes:"main-menu nav"  %}
```

 - **id** - Wrapping UL element's `id` attribute.

```        

    {% catnav id:"nav-menu-1" %}
```

 - **categories** - Category or set of categories to generate the navigation for. By default current page's category is used. Multiple categories can be specified by wrapping them into double quotes and separating with spaces.

```        

    {% catnav categories:"flowers seeds"  %}
```

If asterisk `*` is used as categories value, then navigation is generated for all categories. Well suitable for main navigation usage.

```        

    {% catnav categories:*  %}
```



 - **depth** - How many levels deep to generate the navigation. By default infinite depth is used. 

```        

    {% catnav depth:2  %}
```


### Liquid tag: breadcrumbs

Generates a HTML list of pages leading to current page. 

Example

    {% breadcrumbs %}

**Supported attributes:**
 
 - **classes** - Wrapping UL element's `class` attribute. Multiple classes can be specified by wrapping them into double quotes and separating with spaces.

```        

    {% breadcrumbs classes:"hansel gretel"  %}
```

 - **id** - Wrapping UL element's `id` attribute.

```        

    {% breadcrumbs id:"hg1" %}
```

 - **home** - Home elements title text. By default site's index page title is used or "Home". 

```        

    {% breadcrumbs home:"My site"  %}
```


### That's it ?

Currently yes. More stuff to be added soon.