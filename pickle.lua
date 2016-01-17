
local P = require "Pickle"
local F = require "Pickle.Filter"
local Core = require "core/Core"
local Layout = require "core/Layout"
local Page = require "core/Page"
local Redirect = require "core/Redirect"
local NavItem = require "core/NavItem"

P.configure_default{
	port = 4001,
}
P.configure{
	build_path = "build/",
}

Core.setup_site(function()
	title = "Allopoeia"
	url = "http://allopoeia.komiga.com"
	run_years = "2012–2016"
	md_image = "http://lh4.googleusercontent.com/-0cni5iXgy_8/Uf7NKDyANjI/AAAAAAAAALo/ZHUIsfHxxVc/k-inv-256.png"

	disqus_shortname = "komiga"
	analytics_id = "UA-6565507-3"
	analytics_domain_name = nil
	human_date_format = "%d %B %Y"

	nav = {
		home    = NavItem("Ascend" , nil, "//komiga.com"),
		archive = NavItem("Archive", nil, "/"),
		atom    = NavItem("Atom"   , nil, "/atom.xml"),
	}

	nav_default = {
		nav.home,
		nav.archive,
		nav.atom,
	}

	-- Replacement fields:
	--    %about_author% - the author's about-url
	--    %year_range% - the post's modification years
	--    %author% - the author's moniker
	--    %author_linked% - the author's moniker, linking to %about_author%
	copyright_notice = {
		simple = {
			url = nil,
			pre_text = "&copy; %year_range% %author_linked%",
			url_text = "",
			post_text = "",
		},
		cc_by_nc_sa_4_0 = {
			url = "http://creativecommons.org/licenses/by-nc-sa/4.0/",
			pre_text = "&copy; %year_range% %author_linked%, under license ",
			url_text = "Creative Commons BY-NC-SA 4.0",
			post_text = "",
		},
	}

	author = {
		coranna = {
			display_name = "Coranna Howard",
			about_url = "//komiga.com",
			default_copyright_notice = copyright_notice.cc_by_nc_sa_4_0,
		},
	}
end)

Site.posts = {}

local Composition = require "src/Composition"

P.filter("static", F.copy)
P.filter("layout", Composition.layout)
P.filter("bits", Core.template_wrapper)
P.filter("post", Composition.post)
P.filter("page", Composition.page)

Core.setup_filters()
P.post_collect(Core.group_post_collect(Site.posts))

P.post_collect(function()
	for _, post in pairs(Site.posts) do
		if post.legacy_url then
			local r = Redirect(post.legacy_url, canonical_url(post.url))
			P.output(nil, post.legacy_url, r, r)
		end
	end
end)

P.post_collect(function()
	Site.posts_by_file = {}
	Site.posts_chrono = {}
	Site.posts_chrono_reverse = {}
	for _, post in pairs(Site.posts) do
		Site.posts_by_file[post.file] = post
		table.insert(Site.posts_chrono, post)
		table.insert(Site.posts_chrono_reverse, post)
	end
	table.sort(Site.posts_chrono, function(l, r)
		return l.published < r.published
	end)
	table.sort(Site.posts_chrono_reverse, function(l, r)
		return l.published > r.published
	end)
end)
