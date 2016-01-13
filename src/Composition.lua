
local U = require "togo.utility"
local P = require "Pickle"
local Core = require "core/Core"
local Layout = require "core/Layout"
local Page = require "core/Page"
local NavItem = require "core/NavItem"
local M = U.module("Composition")

local page_vf = P.ValueFilter("AllopoeiaPage")
:filter("nav_active", NavItem)

M.page = Page.compose(page_vf, nil, {
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
:filter("url", "string", function(_, value)
	local cat, y, m, title, ext = string.match(value, "^/(.*)/(%d%d%d%d)%-(%d%d)%-%d%d%-(.*)(%.%w*)$")
	if not y then
		return nil, string.format("malformed URL: %s", value)
	end
	return string.format("/%s/%s/%s/%s%s", cat, y, m, title, ext)
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
:filter("sp_prev_url", "string")
:filter("sp_prev_title", "string")
:filter("sp_next_url", "string")
:filter("sp_next_title", "string")
:filter("nav_active", NavItem)
:filter("disable_header", "boolean")
:filter("enable_comments", "boolean")
:filter("disqus_legacy_identifier", "boolean")

M.post = Page.compose(post_vf, Site.posts, {
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
	nav_active = nil,
	disable_header = false,
	enable_comments = false,
	disqus_legacy_identifier = false,
})

local layout_vf = P.ValueFilter("AllopoeiaLayout")
:filter("article_class", "string")
:filter("article_styles", "string")
:filter("article_font", "string")
:filter("custom_post_header", "boolean")

M.layout = Layout.compose(layout_vf, {
	article_class = nil,
	article_styles = nil,
	article_font = nil,
	custom_post_header = nil,
})

return M
