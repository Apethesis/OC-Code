local args = {...}
if #args < 1 then
    print("Usage:")
    print("     multiListener listenPort")
    print("     multiListener 3")
    return
end
local component = require("component")
local event = require("event")
local modem = component.modem; modem.open(tonumber(args[1]))
while true do
    local _, _, _, port, _, message = event.pull("modem_message")
    if port == tonumber(args[1]) then
        print("Attempting to start replicator...")
        os.execute("replicateWorld "..message)
    end
end