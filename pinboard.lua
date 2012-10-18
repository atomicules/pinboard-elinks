--Save current page to pinboard
--source from your ~/.elinks/hooks.lua file with `dofile("pinboard.lua")`

function addto_pinboard (description)
	pinboardBase = 'https://pinboard.in/add?'
	url = current_url ()
	title = current_title ()
	docURL = pinboardBase..'url='..encodeURIComponent(url)..'&title='..encodeURIComponent(title)..'&description='..encodeURIComponent(description)..' ','Pinboard','toolbar=no,width=700,height=350';
    return docURL
end
	bind_key ("main", "Alt-p",
		function () return "goto_url", addto_pinboard () end)
	--Alt key is the Apple key on OSX

	bind_key ("main", "Alt-p",
		function () xdialog("",
			function (description)
				return "goto_url",
				addto_pinboard (description) 
		end)
	end)

function readlater_pinboard ()
	pinboardBase = 'https://pinboard.in/add?'
	url = current_url ()
	title = current_title ()
	docURL = pinboardBase..'later=yes&noui=yes&jump=close&url='..encodeURIComponent(url)..'&title='..encodeURIComponent(title)..' ','Pinboard','toolbar=no,width=100,height=100';
    return docURL
end
	bind_key ("main", "Alt-l",
		function () return "goto_url", readlater_pinboard () end)


function encodeURIComponent (component)
	component = string.gsub(component, "%s", "%%21")
	component = string.gsub(component, "'", "%%27")
	component = string.gsub(component, "%(", "%%28")
	component = string.gsub(component, "%)", "%%29")
	component = string.gsub(component, "%*", "%%2A")
	return component
end


