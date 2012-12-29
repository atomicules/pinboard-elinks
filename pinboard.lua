--Pinboard tools for ELinks
--source from your ~/.elinks/hooks.lua file with `dofile("pinboard.lua")`

--ALT+p to save a bookmark. Brings up an XDialog, first row is to enter a description, second row is for tags
--ALT+l to read later. 
--Reformats the mobile site to be better for ELinks

--In order to be able to delete need to enter auth_token in `.netrc`. See README
local pb_base = 'https://pinboard.in/add?'
local pb_url

function addto_pinboard (description, tags)
	local url = current_url ()
	local title = current_title ()
	local doc_url = pb_base..'url='..escape (url)..'&title='..escape (title)..'&description='..escape (description)..'&tags='..escape (tags)..'&next='..escape (url)..' ','Pinboard','toolbar=no,width=700,height=350';
    return doc_url
end
	bind_key ("main", "Alt-p",
		function () xdialog("<Description>", "<Tags>",
			function (description, tags)
				return "goto_url",
				addto_pinboard (description, tags) 
		end)
	end)


function readlater_pinboard ()
	local url = current_url ()
	local title = current_title ()
	local doc_url = pb_base..'later=yes&next=same&noui=yes&jump=close&url='..escape (url)..'&title='..escape (title)..' ','Pinboard','toolbar=no,width=100,height=100';
	--Uses &next=same to immediately return to page being bookmarked
    return doc_url
end
	bind_key ("main", "Alt-l",
		function () return "goto_url", readlater_pinboard () end)


function pre_format_html_hook (url, html)
	--strip stuff that shouldnae be displayed anyway
	if string.find(url, "://m.pinboard.in") then
		pb_url = url --since can't pass additional args to new_edit_link
		html = string.gsub (html, '<div name="edit_checkbox".-</div>', '') --ok as no child divs
		html = string.gsub (html, '<div class="star.-</div>', '') --ok as no child divs
		html = string.gsub (html, '<fieldset id="bulk_edit_box">.-</fieldset>', '') --do this instead of parent div
		html = string.gsub (html, '<a class="bookmark_title.-edit</a>', new_edit_link)
		html = string.gsub (html, '<div class="delete_link".-</div>', '')
		html = string.gsub (html, '<div style="display:inline" class="read">.-</div>', '')
		html = string.gsub (html, '<div id="edit_bookmark_form".-</form>\n  \n</div>', '')
		return html
	elseif string.find(url, "://pinboard.in/add%?url=") then --need to escape the ? here
		--Remove delete and destroy from the add page.
		html = string.gsub (html, '<div style="display:inline" id="delete_.-</div>', '')
		html = string.gsub (html, '<div style="visibility:hidden;display:none" class="delete_div" id="destroy_.-</div>', '')
		return html
	end
end


function new_edit_link (s)
	local _,_,link = string.find (s, '<a class="bookmark_title.-href="(.-)"')
	local login,token = readnetrc()
	--But need to escape any %X (where X is a digit) in the URL http://stackoverflow.com/a/6705995/208793
	link = string.gsub (link, "([%%])", "%%%1")
	if string.find(pb_url, "/b:") and not (login == nil) then --if on individual bm page, add Delete button as well
		delete_link = '<a href="https://api.pinboard.in/v1/posts/delete?url='..link..'&auth_token='..login..":"..token..'" class="delete">Delete</a>'
	else
		delete_link = ''
	end
	local replacement = string.gsub (s, '<a onclick="edit.-</a>', '<a href="'..pb_base..'url='..link..'" class="edit">Edit</a> '..delete_link..'<br>')
	return replacement
end


function readnetrc () 
	local login
	local password
	local getnextlines = 0
	for line in io.lines (os.getenv("HOME").."/.netrc") do
		if string.find (line, "pinboard.in") then
			if string.find (line, "login") then
				--login and password on one line	
				_,_,login,password = string.find(line, "login%s(%w+)%spassword%s(%w+)")
			else
			--else need to get from the next two lines	
				getnextlines = 2
			end
		elseif getnextlines > 0 then
			if string.find (line, "login") then
				_,_,login = string.find(line, "login%s(%w+)")
			elseif string.find (line, "password") then
				_,_,password = string.find(line, "password%s(%w+)")
			end	
			getnextlines = getnextlines - 1
		end
	end
	return login,password
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
