------------------------------------------
-- PROJECT:     MTAImports 1.0
-- LICENSE:     See LICENSE in the top level directory
-- FILE NAME:   g_import.lua
-- PURPOSE:     Provide import function for resource entry level
-- GITHUB REPO: https://github.com/BeagleTeam/MTAImports
------------------------------------------


import = false

function import(resourceName, defineSpace, spaceName)
	local headCode = [[local resourceName = "]] .. resourceName .. [[";]]
	if (defineSpace) then
		headCode = headCode .. [[local defineSpace = ]] .. defineSpace .. [[;]]
	end
	if (spaceName) then
		headCode = headCode .. [[local spaceName = "]] .. spaceName .. [[";]]
	end

	local importCode = headCode .. [[
		if (not _G.resources) then _G.resources = {} end

		local resources = _G.resources -- Store a referrence to resources

		if type(resourceName) ~= "string" then error("bad argument #1 to 'import' (string expected)", 2) end
		if defineSpace and defineSpace ~= true then error("bad argument #2 to 'import' (boolean expected)", 2) end
		if spaceName and type("spaceName") ~= "string" then error("bad argument #3 to 'import' (string expected)", 2) end

		local importResource = getResourceFromName(resourceName)
		if not importResource then error("resource '"..resourceName.."' not found", 2) end
		if getResourceState(importResource) ~= "running" then error("resource '"..resourceName.."' is not running", 2) end
		if importResource == getThisResource() then error("can't import from same resource", 2) end

		local function onStart(resource)
			if (resource) then
				if (getResourceName(resource) == resourceName) then
					resources[getResourceName(resource)] = resource
				end
			end
		end
		if (dxGetStatus) then
			addEventHandler("onClientResourceStart", root, onStart)
		else
			addEventHandler("onResourceStart", root, onStart)
		end

		local function onStop(resource)
			if (resource) then
				if (getResourceName(resource) == resourceName) then
					resources[getResourceName(resource)] = nil
				end
			end
		end
		if (dxGetStatus) then
			addEventHandler("onClientResourceStop", root, onStop)
		else
			addEventHandler("onResourceStop", root, onStop)
		end

		resources[resourceName] = importResource

		spaceName = defineSpace and (spaceName or resourceName)

		local space = _G
		if spaceName then
			space = {}
			_G[spaceName] = space
		end

		for _, functionName in ipairs(getResourceExportedFunctions(importResource)) do
			space[functionName] = function(...)
				return call(resources[resourceName], functionName, ...)
			end
		end
	]]
	return importCode
end
