
local U = require "togo.utility"
local P = require "Pickle"
local Core = require "core/Core"
local M = U.module("Support")

function _G.anchor_targeted(target, url, text)
	U.type_assert(target, "string", true)
	U.type_assert(url, "string")
	U.type_assert(text, "string")
	if target then
		target = string.format([[target="_%s" ]], target)
	end
	return string.format([[<a %shref="%s">%s</a>]], target or "", url, text)
end

function _G.anchor(url, text)
	U.type_assert(url, "string")
	U.type_assert(text, "string")
	return anchor_targeted(nil, url, text)
end

function _G.anchor_ext(url, text)
	U.type_assert(url, "string")
	U.type_assert(text, "string")
	return anchor_targeted("blank", url, text)
end

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
