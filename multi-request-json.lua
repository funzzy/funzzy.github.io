-- Module instantiation
local cjson = require "cjson"
local cjson2 = cjson.new()
local cjson_safe = require "cjson.safe"

-- Initialize the pseudo random number generator
-- Resource: http://lua-users.org/wiki/MathLibraryTutorial
math.randomseed(os.time())
math.random(); math.random(); math.random()

-- Shuffle array
-- Returns a randomly shuffled array
function shuffle(paths)
    local j, k
    local n = #paths

    for i = 1, n do
        j, k = math.random(n), math.random(n)
        paths[j], paths[k] = paths[k], paths[j]
    end

    return paths
end

-- Load URL paths from the file
function load_request_objects_from_file(file)
    local data = {}
    local content

    -- retrieve the content of a URL
    local http = require("socket.http")
    local body, code = http.request(file)
    if not body then error(code) end

    print("TOTOTOTOT=" .. body)
    
    -- Translate Lua value to/from JSON
    data = cjson.decode(body)

    return shuffle(data)
end

print("TOTOTOTOT")

-- Load URL requests from file
requests = load_request_objects_from_file("https://raw.githubusercontent.com/funzzy/funzzy.github.io/master/requests.json")

-- Check if at least one path was found in the file
if #requests <= 0 then
    print("multiplerequests: No requests found.")
    os.exit()
end

print("multiplerequests: Found " .. #requests .. " requests")

-- Initialize the requests array iterator
counter = 1

request = function()
    -- Get the next requests array element
    local request_object = requests[counter]

    -- Increment the counter
    counter = counter + 1

    -- If the counter is longer than the requests array length then reset it
    if counter > #requests then
        counter = 1
    end

    -- Return the request object with the current URL path
    return wrk.format(request_object.method, request_object.path, request_object.headers, request_object.body)
end
