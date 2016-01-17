
local U = require "togo.utility"
local P = require "Pickle"
local Core = require "core/Core"
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

local function parse_time(_, value)
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
			post.legacy_url = string.format("/%s/%s/%s/%s.html", path, y, m, title)
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
:filter("legacy_url", "string")
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
:filter("sp_prev_url", "string")
:filter("sp_prev_title", "string")
:filter("sp_next_url", "string")
:filter("sp_next_title", "string")

local post_composition = Page.compose(post_vf, Site.posts, {
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

	sp_prev_url = nil,
	sp_prev_title = nil,
	sp_next_url = nil,
	sp_next_title = nil,
})

M.post = function(source, file, destination)
	local p = post_composition(source, file, destination)
	p.bare_content = p.template:content(p)
	return p
end

local layout_vf = P.ValueFilter("AllopoeiaLayout")

M.layout = Layout.compose(layout_vf, {
})

return M
