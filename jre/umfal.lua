--[[ UMFAL - Unified Multi-File Applications Loader
	 Author - AtomicScience
]]
local filesystem = require("filesystem")

-- Constants:
local PATH_TO_APPLICATIONS = "/usr/bin"
local MANIFEST_FILE_NAME   = "manifest.json"
----------------------------------------------------------------
local umfal = {}

local function addLibraryMeta(library)
    library.errorManager = {}

    local metatable = {__index = function (subjectTable, applicationName)
        local application = umfal.loadApplication(applicationName)

        library[applicationName] = application

        return application
    end}

    setmetatable(library, metatable)

    return library
end

local function getBlankApplicationWithMeta(applicationName)
    local blankApplication = {}
    blankApplication.name = applicationName

    local metatable = {__index = function (subjectTable, nodeName)
        local node = umfal.loadNode(applicationName, {nodeName})

        blankApplication[nodeName] = node

        return node
    end}

    setmetatable(blankApplication, metatable)

    return blankApplication
end

local function getFolderWithMeta(applicationName, path)
    local folder = {}
    folder.path = path

    local metatable = {__index = function (subjectTable, nodeName)
        local newPath = umfal.appendToPath(path, nodeName)

        local node = umfal.loadNode(applicationName, newPath)

        folder[nodeName] = node

        return node
    end}

    setmetatable(folder, metatable)

    return folder
end

---
umfal = addLibraryMeta(umfal)
---

----------------------------------------------------------------

----- Application functions

function umfal.loadApplication(applicationName)
    local application = getBlankApplicationWithMeta(applicationName)

    if not umfal.applicationFolderExists(applicationName) then
        umfal.errorManager.applicationFolderNotFound(applicationName)
    end

    application.manifest = umfal.loadManifest(umfal.getPathToManifest(applicationName))

    if not application.manifest.valid then
        umfal.errorManager.invalidManifestFile(applicationName, application.manifest.error)
    end

    return application
end

function umfal.applicationFolderExists(applicationName)
    return filesystem.isDirectory(umfal.getPathToApplication(applicationName))
end

function umfal.applicationHasManifest(applicationName)
    local manifestFileExists   = filesystem.exists(umfal.getPathToManifest(applicationName))
    local manifestFileIsFolder = filesystem.isDirectory(umfal.getPathToManifest(applicationName))

    return manifestFileExists and not manifestFileIsFolder
end

function umfal.getPathToApplication(applicationName)
    return PATH_TO_APPLICATIONS .. "/" .. applicationName
end

----- Node functions

function umfal.loadNode(applicationName, path)
    if path == nil or type(path) ~= "table" or #path == 0 then
        umfal.errorManager.nodeInvalidPathArgument(applicationName)
    end

    local node = {}

    local nodeName = path[#path]

    if not umfal.nodeExists(applicationName, path) then
        umfal.errorManager.nodeDoesNotExist(applicationName, nodeName)
    end

    if umfal.nodeIsFolder(applicationName, path) then
        node = getFolderWithMeta(applicationName, path)
    elseif umfal.nodeIsModule(applicationName, path) then
        node = umfal.loadModule(applicationName, path)
    else
        umfal.errorManager.moduleHasWrongType(applicationName, nodeName)
    end

    return node
end

function umfal.loadModule(applicationName, path)
    local pathToModule = umfal.getModuleFilepath(applicationName, path)

    local loadedModule = dofile(pathToModule)

	if loadedModule then
		return loadedModule
	else
		error("Failed to load module!")
	end
end

function umfal.nodeExists(applicationName, path)
    local possibleFolderFilepath = umfal.getFolderFilepath(applicationName, path)
    local possibleModuleFilepath = umfal.getModuleFilepath(applicationName, path)

    return filesystem.exists(possibleFolderFilepath) or filesystem.exists(possibleModuleFilepath)
end

function umfal.nodeIsFolder(applicationName, path)
    local folderFilepath = umfal.getFolderFilepath(applicationName, path)

    return filesystem.isDirectory(folderFilepath)
end

function umfal.nodeIsModule(applicationName, path)
    local moduleFilepath = umfal.getModuleFilepath(applicationName, path)

    return filesystem.exists(moduleFilepath) and not filesystem.isDirectory(moduleFilepath)
end

function umfal.getFolderFilepath(applicationName, path)
    local stringPath = umfal.getPathToApplication(applicationName)

    for i = 1, #path do
        stringPath = stringPath .. "/" .. path[i]
    end

    return stringPath
end

function umfal.getModuleFilepath(applicationName, path)
    local stringPath = umfal.getFolderFilepath(applicationName, path)

    stringPath = stringPath .. ".lua"

    return stringPath
end


function umfal.appendToPath(path, nodeName)
    local newPath = {}

    for i = 1, #path do
        newPath[i] = path[i]
    end

    table.insert(newPath, nodeName)

    return newPath
end
----- Manifest functions

function umfal.getPathToManifest(applicationName)
    return umfal.getPathToApplication(applicationName) .. "/" .. MANIFEST_FILE_NAME
end

function umfal.loadManifest(pathToManifest)
    local manifest = {}
    manifest.valid = true

    -- Since v0.1 does not require any manifest information,
    -- this function is only a stub.

    return manifest
end

----- Error manager
function umfal.errorManager.applicationFolderNotFound(applicationName) 
    error("Failed to load an app `" .. applicationName .. "`: no app folder found in " .. PATH_TO_APPLICATIONS, 2)
end

function umfal.errorManager.applicationManifestNotFound(applicationName) 
    error("Failed to load an app `" .. applicationName .. "`: " .. MANIFEST_FILE_NAME .. " file not found", 2)
end

function umfal.errorManager.applcationManifestInvalid(applicationName, reason) 
    error("Failed to load an app `" .. applicationName .. "`: " .. MANIFEST_FILE_NAME .. "  is invalid. Reason - " .. reason, 2)
end

function umfal.errorManager.nodeInvalidPathArgument(applicationName) 
    error("Failed to load a node: path argument invalid", 2)
end

function umfal.errorManager.nodeDoesNotExist(applicationName, nodeName)
    error("Failed to load a node `" .. nodeName .. "`: file does not exist", 2)
end

function umfal.errorManager.failedToLoadModule(applicationName, moduleName) 
    error("Failed to load module `" .. moduleName .. "`: unknown error", 2)
end

function umfal.errorManager.moduleHasWrongType(applicationName, moduleName)
    error("Failed to load module `" .. moduleName .. "`: file is not a .lua script", 2)
end

return umfal