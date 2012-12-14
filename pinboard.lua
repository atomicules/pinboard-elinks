--Pinboard tools for ELinks
--source from your ~/.elinks/hooks.lua file with `dofile("pinboard.lua")`

--ALT+p to save a bookmark. Brings up an XDialog, first row is to enter a description, second row is for tags
--ALT+l to read later. 


function addto_pinboard (description, tags)
	pinboardBase = 'https://pinboard.in/add?'
	url = current_url ()
	title = current_title ()
	docURL = pinboardBase..'url='..escape (url)..'&title='..escape (title)..'&description='..escape (description)..'&tags='..escape (tags)..' ','Pinboard','toolbar=no,width=700,height=350';
    return docURL
end
	bind_key ("main", "Alt-p",
		function () xdialog("<Description>", "<Tags>",
			function (description, tags)
				return "goto_url",
				addto_pinboard (description, tags) 
		end)
	end)


function readlater_pinboard ()
	pinboardBase = 'https://pinboard.in/add?'
	url = current_url ()
	title = current_title ()
	docURL = pinboardBase..'later=yes&next=same&noui=yes&jump=close&url='..escape (url)..'&title='..escape (title)..' ','Pinboard','toolbar=no,width=100,height=100';
	--Uses &next=same to immediately return to page being bookmarked
    return docURL
end
	bind_key ("main", "Alt-l",
		function () return "goto_url", readlater_pinboard () end)


function pre_format_html_hook (url, html)
	--strip stuff that shouldnae be displayed anyway
	if string.find(url, "://m.pinboard.in") then
		html = string.gsub (html, '<div name="edit_checkbox".-</div>', '') --ok as no child divs
		html = string.gsub (html, '<div class="star.-</div>', '') --ok as no child divs
		html = string.gsub (html, '<fieldset id="bulk_edit_box">.-</fieldset>', '') --do this instead of parent div
		html = string.gsub (html, '<a onclick="edit.-</a>', '') --Have to target these children of edit_links div directly
		html = string.gsub (html, '<div class="delete_link".-</div>', '')
		html = string.gsub (html, '<div style="display:inline" class="read">.-</div>', '')
		html = string.gsub (html, '<div id="edit_bookmark_form".-</form>\n  \n</div>', '')
		return html
	end
end


--The following taken from the contrib hooks.lua sample
function hx (c)
    return string.char((c >= 10 and (c - 10) + string.byte ('A')) or c + string.byte ('0'))
end

function char2hex (c)
    return '%'..hx (string.byte (c) / 16)..hx (math.mod(string.byte (c), 16))
end

function escape (str)
    return string.gsub (str, "(%W)", char2hex)
end
--end stealing


--Todo and Ideas
--==============

--Always redirect to mobile site? But this conflicts with the actual bookmarking up above. So maybe not!
--[[
function follow_url_hook(url)
	if string.find(url, "://pinboard.in") then
		return "http://m.pinboard.in"
	else
		return url
	end
end
--]]

--Re-format the mobile site, remove any buttons that use javascript since that doesn't work in ELinks. Also remove stuff where CSS is "display: none", but ELinks is displaying anyway. Just make nice and basic.

--Re-format the mobile site and see if can add Lua implementatons for deleting, editing bookmarks. For deleting just need to make a POST. If can't do this in browser could do it in Curl, via Lua.

--Tab sets would be cool, but don't think there is anyway to get list of open tabs via Lua interface? Perhaps read session snapshot from bookmarks file? Hmmm...
