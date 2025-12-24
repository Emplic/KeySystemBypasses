-- \\ returns true on neox hub key system

if not getgenv then getgenv = function() return _G end end

local NeoxBypass = {
    Key = "hasanxzaynisakuck",
    Enabled = true,
    Debug = true
}

local originalFunctions = {
    request = request,
    writefile = writefile,
    loadstring = loadstring
}

local function bypassRequest(options)
    if NeoxBypass.Debug then
        print("[Femboy loader] Request intercepted:", options.Url)
    end

    if options.Url == "https://neoxsoftworks.eu/api/validate-key" then
        if NeoxBypass.Debug then
            print("[Femboy loader] Authentication request intercepted - returning success")
        end
        
        return {
            StatusCode = 200,
            Body = '{"valid":true,"message":"Key verification successful"}',
            Headers = {}
        }
    end
    
    return originalFunctions.request(options)
end

local function bypassWritefile(path, content)
    if path == "neoxkey.txt" then
        if NeoxBypass.Debug then
            print("[Femboy loader] Blocked key file write:", content)
        end
        return
    end
    
    return originalFunctions.writefile(path, content)
end

local function bypassLoadstring(content, name)
    if content and string.find(content, "NEOXHUBMAIN") then
        if NeoxBypass.Debug then
            print("[Femboy loader] Main script loading detected")
        end
    end
    
    return originalFunctions.loadstring(content, name)
end

if NeoxBypass.Enabled then
    getgenv().request = bypassRequest
    getgenv().writefile = bypassWritefile
    getgenv().loadstring = bypassLoadstring
    
    if not isfile("neoxkey.txt") then
        originalFunctions.writefile("neoxkey.txt", NeoxBypass.Key)
    end
else
    print("disabled furry femboy bypass")
end

return NeoxBypass
