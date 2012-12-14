# Pinboard Lua Script for ELinks

Adds the following functionality to ELinks:

- "ALT+p" Adds current page to Pinboard, with dialog box for description and tags
- "ALT+l" Adds current page to Pinboard and marks as "Read Later"

##Installation

Source from your `~/.elinks/hooks.lua` file with `dofile("pinboard.lua")`

##Notes

Developed and tested with ELinks 0.12pre5 and Lua 5.0 (both of which are well out of date, but if it works there it should work with if you are building from the repository master and using Lua 5.1, etc; and if it doesn't since you are clever enough to build yourself I'm sure you can adapt the scripts as necessary). 

##Extras

Rather than use Lua to hijack the goto\_url box, just add the following to `~/.elinks/elinks.conf` to search your Pinboard bookmarks using a `p` prefix:

	set protocol.rewrite.smart.p = "https://m.pinboard.in/search/?mine=1&query=%s"

##Todo

See the notes at the bottom of the source code.
