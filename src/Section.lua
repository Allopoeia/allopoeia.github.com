
local U = require "togo.utility"
local M = require "core/Section"

M.tpl_content = [[<h%d class="separator">%s%s</h%d>]]

function M.sub(name, level, id)
	return M.make(nil, name, name, nil, nil, id, level or 2)
end

return M
