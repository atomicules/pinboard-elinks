# Pinboard Lua Script for ELinks

Adds the following functionality to ELinks:

- "CTRL+p" Adds current page to Pinboard, with dialog box for description and tags
- "CTRL+o" Adds current page to Pinboard and marks as "Read Later"
- Reformats the mobile site to be better for ELinks (Adds working edit/delete links)

Javascript support in ELinks is a bit lacking (it's never worked well for me anyway) so it's not possible to use the Pinboard bookmarklets. Lua support in ELinks is much better, so this script does what the bookmarklets would do, but via lua. Since CSS support in ELinks is also a bit lacking - there's a lot of cruft on the Pinboard mobile sight in ELinks (stuff that's set as `display: none`, etc) - this script also cleans that up. The Pinboard edit and delete links won't work in ELinks because of javascript again, so this script generates replacement ones: Editing is done by "saving" the bookmark again, since the add page works fine; Deleting is done via the AP, since it is immediately destructive the delete link is only visible on the individual bookmark page, not when browsing through a list of bookmarks.

##Installation

Source from your `~/.elinks/hooks.lua` file with `dofile("pinboard.lua")`
If you want to be able to delete bookmarks on Pinboard then you need to add in your auth\_token to a `~/.netrc` file in the following format:

	machine pinboard.in
		login <Your pinboard login name>
		password <Your pinboard API token>

##Notes

Developed and tested with ELinks 0.12pre6 and Lua 5.1.4.

##Extras

Rather than use Lua to hijack the goto\_url box, just add the following to `~/.elinks/elinks.conf` to search your Pinboard bookmarks using a `p` prefix:

	set protocol.rewrite.smart.p = "https://m.pinboard.in/search/?mine=1&query=%s"

##Todo

- Considered always redirecting to mobile site, but conflicted with saving the actual bookmark, so not doing for now.
- Tab sets would be cool, but don't think there is anyway to get list of open tabs via Lua interface? Perhaps read session snapshot from bookmarks file? Hmmm... but then still think I'd need a Pinboard API method to actually save them.
