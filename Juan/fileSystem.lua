local fileSystem = {}

local lfs = require("lfs")
local winapi = require("winapi")

local function isDir(FilePath)
    local cd = lfs.currentdir()
    local exists = lfs.chdir(FilePath) and true or false
    lfs.chdir(cd)
    return exists
end

local function fileExists(FilePath)
    return lfs.attributes(FilePath) ~= nil
end

local function getName(FilePath)
    return FilePath:match("^.+\\(.+)$") or FilePath
end

local function isDrive(FilePath)
    local Name = FilePath:match("^(.+):.+$")
    local Ext = FilePath:match("^.+:(.+)$")
    return #string.format("%s:", Name) == 2 and Ext == "\\"
end

local function getPath(FilePath)
    local path = FilePath:match("^(.+)\\.+$")
    if isDrive(path .. "\\") then
        return path .. "\\"
    end
    return path
end

function fileSystem.open(FilePath)
    if not fileExists(FilePath) then return end

    local File = {}
    File.Name = getName(FilePath)
    File.Type = isDrive(FilePath) and isDir(FilePath) and "Drive" or isDir(FilePath) and "Directory" or "File"
    File.Directory = File.Type ~= "Drive" and getPath(FilePath) or nil
    File.FilePath = FilePath

    function File:GetAttributes()
        return lfs.attributes(FilePath)
    end

    function File:Read()
        if File.Type == "File" then
            local openFile = io.open(FilePath, "r")
            if openFile then
                local Data = openFile:read("*a")
                openFile:close()
                return Data
            end
        end
    end

    function File:Write(Data, WriteMode)
        if File.Type ~= "File" then return end
        local openFile = io.open(FilePath, WriteMode or "w")
        if openFile then
            openFile:write(Data)
            openFile:close()
        end
    end

    function File:Copy(Path)
        if File.Type ~= "File" then return end
        local Data = File:Read()
        return fileSystem.write(Path, Data)
    end

    function File:Move(Path)
        local success = os.rename(File.FilePath, Path)
        if success then
            File:close()
            return fileSystem.open(Path)
        end
    end

    function File:Rename(newName)
        local success, err = os.rename(FilePath, File.Directory .. newName)
        local newFile
        if success then
            newFile = fileSystem.open(File.Directory .. newName)
        else
            print(err)
        end

        return newFile
    end

    function File:Delete()
        local success, err = winapi.execute('del "' .. FilePath .. '" /f /s /q')
        if success then
            File:close()
        end
    end

    function File.dir()
        if File.Type ~= "File" then
            return fileSystem.dir(File.FilePath)
        end
    end

    function File:isParentOf(ParentFile)
        if File.Type ~= "Drive" then
            return File.Directory == ParentFile.FilePath
        end
    end

    function File:FindFile(FileName)
        if File.Type == "File" then return end
        return fileSystem.open(File.FilePath .. "\\" .. FileName)
    end

    function File:close()
        File = nil
    end

    return File
end

function fileSystem.write(FilePath, Data)
    local File = io.open(FilePath, "w")
    if File == nil then return end
    File:write(Data)
    File:close()
    return fileSystem.open(FilePath)
end

function fileSystem.read(FilePath)
    local File = fileSystem.open(FilePath)
    local Data
    if File then
        Data = File.Type == "File" and File:Read() or nil
        File:close()
    end
    return Data
end

function fileSystem.copy(FilePath, CopyPath)
    local Original = fileSystem.open(FilePath)
    if Original then
        return fileSystem.write(CopyPath, Original:Read())
    end
end

function fileSystem.mkdir(FilePath)
    if fileExists(FilePath) then
        return fileSystem.open(FilePath)
    end
    local FullPath = FilePath
    local Name = getName(FilePath)
    local FilePath = getPath(FilePath)
    local cd = lfs.currentdir()
    lfs.chdir(FilePath)
    lfs.mkdir(Name)
    lfs.chdir(cd)
    return fileSystem.open(FullPath)
end

function fileSystem.dir(FilePath)
    local Files = {}
    if not fileExists(FilePath) or not isDir(FilePath) then return Files end
    if isDir(FilePath) then
        local Count = 1
        for file in lfs.dir(FilePath) do
            if file == ".." or file == "." or not fileExists(FilePath .. "\\" .. file) then goto continue end
            Files[Count] = fileSystem.open(FilePath .. "\\" .. file)
            Count = Count + 1
            ::continue::
        end
    end
    return Files
end

function fileSystem.delete(FilePath)
    local File = fileSystem.open(FilePath)
    if File then
        File:Delete()
    end
end

function fileSystem.cd()
    return fileSystem.open(lfs.currentdir())
end

function fileSystem.exists(FilePath)
    if FilePath == nil then return end
    return fileExists(FilePath)
end

return fileSystem
