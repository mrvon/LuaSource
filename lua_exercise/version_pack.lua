local version_num        = '1.0'
local version_text       = 'return 0.9'

local version_file_name  = 'updateVersion.lua'
local zip_pack_file_name = version_num .. '.zip'
local zip_compress_level = '9'

-- Warning, export file exclude modification by version($revision_from)
local revision_from    = "16932"
local revision_to      = "16942"
local repository       = 'http://192.168.1.200:81/svn/prj_x/myGame-debug'
local target_directory = "./"

require "svn_export"

function main()
    local target_temp_directory = target_directory .. version_num .. "/"
 
    -- clean
    rmdir(target_temp_directory)

    -- create_version_file
    mkdir(target_temp_directory .. version_file_name)
    local version_f = assert(io.open(target_temp_directory .. version_file_name, "w+"))
    version_f:write(version_text)
    version_f:flush()
    version_f:close()

    svn_export(revision_from, revision_to, repository, target_temp_directory)

    -- zip_compress
    rmdir(zip_pack_file_name)
    local zip_cmd = string.format("7za.exe a -tzip %s %s/*", zip_pack_file_name, target_temp_directory)
    print(zip_cmd)
    os.execute(zip_cmd)

    -- clean
    rmdir(target_temp_directory)
end

main()
