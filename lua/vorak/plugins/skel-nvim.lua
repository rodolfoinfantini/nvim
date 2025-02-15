---@diagnostic disable: param-type-mismatch
return {
    "motosir/skel-nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local skeld = require("skel-nvim.defaults")

        local function cs_namespace_callback2(config)
            local currentBuffer = vim.api.nvim_get_current_buf()
            local bufferName = vim.api.nvim_buf_get_name(currentBuffer)
            local filePath = vim.fn.fnamemodify(bufferName, ":p")
            local currentDirectory = vim.fn.fnamemodify(filePath, ":h")
            local finalName = vim.fn.fnamemodify(filePath, ":t:r")
            local namespace = ""

            while true do
                local csprojFiles = vim.fn.glob(currentDirectory .. "/*.csproj", true, true)
                if #csprojFiles > 0 then
                    local csprojFileName = vim.fn.fnamemodify(csprojFiles[1], ":t:r")
                    namespace = csprojFileName .. "."

                    local projectFolderPath = vim.fn.fnamemodify(csprojFiles[1], ":.")
                    projectFolderPath = string.gsub(projectFolderPath, "[/\\]" .. csprojFileName .. ".csproj$", "")

                    print(projectFolderPath)

                    local relativeFilePath = vim.fn.fnamemodify(filePath, ":.")
                    relativeFilePath = string.gsub(relativeFilePath, "\\", "/")
                    relativeFilePath = string.gsub(relativeFilePath, "^[^/]+/", "")
                    relativeFilePath = string.gsub(relativeFilePath, "/[^/]+$", "")
                    print(relativeFilePath)

                    local fileNamespace = string.gsub(relativeFilePath, "/", ".")
                    namespace = namespace .. fileNamespace
                    break
                else
                    local parentDirectory = vim.fn.fnamemodify(currentDirectory, ":h")
                    if parentDirectory == currentDirectory then
                        -- Reached root directory, break the loop
                        break
                    end
                    currentDirectory = parentDirectory
                end
            end

            return namespace
        end

        local function cs_namespace_callback(config)
            local currentBuffer = vim.api.nvim_get_current_buf()
            local bufferName = vim.api.nvim_buf_get_name(currentBuffer)
            local filePath = vim.fn.fnamemodify(bufferName, ":p")
            local currentDirectory = vim.fn.fnamemodify(filePath, ":h")
            local finalName = vim.fn.fnamemodify(filePath, ":t:r")
            local namespace = ""

            while true do
                -- Find .csproj file in the current directory
                local csprojFiles = vim.fn.glob(currentDirectory .. "/*.csproj", true, true)
                if #csprojFiles > 0 then
                    local csprojFileName = vim.fn.fnamemodify(csprojFiles[1], ":t:r")

                    -- Get project root directory
                    local projectRoot = vim.fn.fnamemodify(csprojFiles[1], ":h")

                    -- Calculate relative path from project root
                    local relativePath = filePath:sub(#projectRoot + 2) -- +2 to skip the separator

                    -- Remove the file name and replace directory separators with dots
                    local fileNamespace = relativePath:gsub("/[^/]+$", ""):gsub("[/\\]", ".")

                    -- Construct the full namespace
                    namespace = csprojFileName .. (fileNamespace ~= "" and "." .. fileNamespace or "")
                    break
                else
                    -- Move to parent directory
                    local parentDirectory = vim.fn.fnamemodify(currentDirectory, ":h")
                    if parentDirectory == currentDirectory then
                        -- Root directory reached, no .csproj file found
                        break
                    end
                    currentDirectory = parentDirectory
                end
            end

            return namespace
        end


        vim.api.nvim_create_user_command('CsNamespace', function()
            print(cs_namespace_callback())
        end, {})


        -- get java package name using maven
        local function java_package()
            local currentBuffer = vim.api.nvim_get_current_buf()
            local bufferName = vim.api.nvim_buf_get_name(currentBuffer)
            local filePath = vim.fn.fnamemodify(bufferName, ":p")
            local currentDirectory = vim.fn.fnamemodify(filePath, ":h")
            local package = ""

            while true do
                local pomFiles = vim.fn.glob(currentDirectory .. "/pom.xml", true, true)
                if #pomFiles > 0 then
                    local pomFileName = vim.fn.fnamemodify(pomFiles[1], ":t:r")
                    package = pomFileName .. "."

                    local projectFolderPath = vim.fn.fnamemodify(pomFiles[1], ":.")
                    projectFolderPath = string.gsub(projectFolderPath, "[/\\]" .. pomFileName .. ".pom.xml$", "")

                    local relativeFilePath = vim.fn.fnamemodify(filePath, ":.")
                    relativeFilePath = string.gsub(relativeFilePath, "\\", "/")
                    relativeFilePath = string.gsub(relativeFilePath, "^[^/]+/", "")
                    relativeFilePath = string.gsub(relativeFilePath, "/[^/]+$", "")

                    local filePackage = string.gsub(relativeFilePath, "/", ".")
                    package = package .. filePackage
                    break
                else
                    local parentDirectory = vim.fn.fnamemodify(currentDirectory, ":h")
                    if parentDirectory == currentDirectory then
                        -- Reached root directory, break the loop
                        break
                    end
                    currentDirectory = parentDirectory
                end
            end

            package = string.gsub(package, "pom.main.java.", "")

            return package
        end

        local function cs_interface_name()
            local filePath = vim.fn.expand("%:p")
            local fileName = vim.fn.fnamemodify(filePath, ":t:r")
            local interfaceName = "I" .. fileName
            return interfaceName
        end

        local function java_interface_name()
            local filePath = vim.fn.expand("%:p")
            local fileName = vim.fn.fnamemodify(filePath, ":t:r")
            local interfaceName = string.gsub(fileName, "Impl$", "")
            return interfaceName
        end

        local function java_service_name()
            local filePath = vim.fn.expand("%:p")
            local fileName = vim.fn.fnamemodify(filePath, ":t:r")
            local interfaceName = string.gsub(fileName, "Controller$", "")
            return interfaceName
        end

        local function file_name_without_extension()
            local filePath = vim.fn.expand("%:p")
            local fileName = vim.fn.fnamemodify(filePath, ":t:r")
            return fileName
        end

        local function cs_service_signature()
            local fileName = file_name_without_extension()
            if string.match(fileName, "^I.*Service$") then
                return "public interface " .. fileName
            else
                return "public sealed class " .. fileName .. " : I" .. fileName
            end
        end

        local function cs_feature_name()
            local fileName = file_name_without_extension()
            fileName = string.gsub(fileName, "Controller$", "")
            fileName = string.lower(fileName)
            return fileName
        end

        local function cs_service_param()
            local fileName = file_name_without_extension()
            fileName = string.gsub(fileName, "Controller$", "")
            return "I" .. fileName .. "Service " .. string.lower(fileName) .. "Service"
        end

        local function cs_service_import()
            local namespace = cs_namespace_callback()
            return string.gsub(namespace, "Controllers", "Services")
        end

        require("skel-nvim").setup {
            templates_dir = vim.fn.stdpath("config") .. "/skeleton",

            skel_enabled = true,

            apply_skel_for_empty_file = true,

            mappings = {
                ['*Enum.cs'] = "Enumcs.skel",
                ['*Service.cs'] = "CsService.skel",
                ['*Controller.cs'] = "CsController.skel",
                ['*Dto.java'] = "DTOJava.skel",
                ['*ServiceImpl.java'] = "ServiceImplJava.skel",
                ['*Service.java'] = "ServiceJava.skel",
                ['*Repository.java'] = "RepositoryJava.skel",
                ['*Converter.java'] = "ConverterJava.skel",
                ['*Controller.java'] = "ControllerJava.skel",
                ['*Enum.java'] = "JavaEnum.skel",
                ['*.java'] = "java.skel",
                ['*.c'] = "c.skel",
                ['*.cs'] = "CSharp.skel"
            },

            substitutions = {
                ['FILENAME']             = file_name_without_extension,
                ['DATE']                 = skeld.get_date,
                ['CS_NAMESPACE']         = cs_namespace_callback,
                ['CS_INTERFACE_NAME']    = cs_interface_name,
                ['CS_SERVICE_SIGNATURE'] = cs_service_signature,
                ['CS_FEATURE_NAME']      = cs_feature_name,
                ['CS_SERVICE_PARAM']     = cs_service_param,
                ['CS_SERVICE_IMPORT']    = cs_service_import,
                ['JAVA_PACKAGE']         = java_package,
                ['JAVA_INTERFACE_NAME']  = java_interface_name,
                ['JAVA_SERVICE_NAME']    = java_service_name
            }
        }
    end
}
