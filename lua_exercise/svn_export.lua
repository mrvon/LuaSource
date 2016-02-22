local lfs = require "lfs"

local revision_from    = "16932"
local revision_to      = "16942"
local repository       = 'http://192.168.1.200:81/svn/prj_x/myGame-debug'
local target_directory = "./"

function os.capture(cmd)
    local f = assert(io.popen(cmd, 'r'))
    local lines = {}
    for line in f:lines() do
        lines[#lines + 1] = line
    end
    f:close()
    return lines
end

local DIR_SEPARATOR = "/"

function aux_mkdir(dir, start)
    if start then
        lfs.mkdir(dir)
    end
end

function recursive_mkdir(dir, start)
    local index = string.find(dir, DIR_SEPARATOR, start)
    if index then
        aux_mkdir(string.sub(dir, 1, index), start)
        recursive_mkdir(dir, index + 2)
    end
end

function mkdir(dir)
    recursive_mkdir(dir)
end

local diff_cmd = string.format("svn diff --summarize -r%s:%s %s", revision_from, revision_to, repository)

local lines = os.capture(diff_cmd)
for i = 1, #lines do
    local line = lines[i]
    local file_url = string.match(line, "^[AM][M]? +(.+)")
    local file_name = string.sub(file_url, #repository + 1)
    local absolute_file_name = target_directory .. file_name

    local file_attribute = lfs.attributes(absolute_file_name)

    local is_export = true

    if file_attribute then
        assert(type(file_attribute) == "table")

        if file_attribute.mode == "directory" then
            is_export = false
        end
    end

    if is_export then
        mkdir(absolute_file_name)

        local export_cmd = string.format("svn export -r %s %s %s%s", revision_to, file_url, target_directory, file_name)
        os.execute(export_cmd)
    end
end
