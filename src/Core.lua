
local U = require "togo.utility"
local P = require "Pickle"
local M = require "core/Core"

function _G.anchor_post(path, text)
	U.type_assert(path, "string")
	U.type_assert(text, "string")

	local file, id = string.match(path, "^(.+)(#.+)$")
	if not file then
		file = path
		id = ""
	end
	local post = Site.posts_by_file[file]
	U.assert(post, "post not found: %s", file)
	return anchor_targeted(nil, canonical_url(post.url) .. id, text)
end

return M
