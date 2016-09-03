
local U = require "togo.utility"
local P = require "Pickle"
local Core = require "src/Core"
local Layout = require "core/Layout"
local Page = require "core/Page"
local NavItem = require "core/NavItem"
local M = U.module("Composition")

local page_vf = P.ValueFilter("AllopoeiaPage")
:filter("article_class", "string")
:filter("article_styles", "string")
:filter("article_font", "string")
-- :filter("custom_post_header", "boolean")
:filter("nav_active", NavItem)

M.page = Page.compose(page_vf, nil, {
	article_class = "generic",
	article_styles = nil,
	article_font = "sans",
	-- custom_post_header = nil,

	nav_active = nil,
})

local function sp_elem_check(post, value)
	if #value >= 1 and #value <= 3 then
		local e1 = value[1]
		local e2 = #value >= 2 and value[2] or ""
		local e3 = #value == 3 and value[3] or false
		if
			U.is_type(e1, "string") and
			U.is_type(e2, "string") and
			U.is_type(e3, "boolean")
		then
			return value
		end
	end
	return nil, "malformed: expected table of {file} or {file, title} or {url, title, true}"
end

local function parse_time(_, value)
	if type(value) == "table" then
		return value
	end
	local time = P.parse_time(value, Core.time_formats.iso)
	if not time then
		return nil, string.format("failed to parse time: %s", value)
	end
	return time
end

local post_vf = P.ValueFilter("AllopoeiaPost")
:filter("url", "string", function(post, value)
	if post.url then
		return value
	end
	local path = U.path_dir(value)
	local file = U.path_file(value)
	local y, m, title = string.match(file, "^(%d%d%d%d)%-(%d%d)%-%d%d%-(.*)%.html$")
	if y then
		if not post.legacy_url then
			post.legacy_url = U.trim_leading_slashes(string.format("%s/%s/%s/%s.html", path, y, m, title))
		end
		file = string.format("%s", title)
	end
	if string.sub(file, -5) ~= ".html" then
		file = string.format("%s/index.html", file)
	end
	return P.path(path, file)
end)
:filter("article_class", "string")
:filter("article_styles", "string")
:filter("article_font", "string")
-- :filter("custom_post_header", "boolean")
:filter("nav_active", NavItem)
:filter("disable_header", "boolean")
:filter("enable_comments", "boolean")
:filter("disqus_legacy_identifier", "boolean")
:filter("legacy_url", "string", function(post, value)
	return U.trim_leading_slashes(value)
end)
:filter("published", "string", parse_time)
:filter("updated", "string", parse_time)
:filter("author", "table")
:filter("categories", "table")
:filter("tags", "table")
:filter("h_title", "string")
:filter("subtitle", "string")
:filter("h_subtitle", "string")
:filter("lp_url", "string")
:filter("lp_url_title", "string")
:filter("lp_url_author", "string")
:filter("sp_prev", "table", sp_elem_check)
:filter("sp_next", "table", sp_elem_check)

M.post = Page.compose(post_vf, Site.posts, {
	article_class = "post",
	article_styles = nil,
	article_font = "sans",
	-- custom_post_header = nil,

	nav_active = nil,
	disable_header = false,
	enable_comments = false,
	disqus_legacy_identifier = false,

	legacy_url = nil,
	published = nil,
	updated = nil,
	author = nil,
	categories = {},
	tags = {},
	h_title = nil,
	subtitle = nil,
	h_subtitle = nil,

	lp_url = nil,
	lp_url_title = nil,
	lp_url_author = nil,

	sp_prev = nil,
	sp_next = nil,
})

local layout_vf = P.ValueFilter("AllopoeiaLayout")

M.layout = Layout.compose(layout_vf, {
})

return M
