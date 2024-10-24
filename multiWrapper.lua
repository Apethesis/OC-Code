local args = {...}
local component = require("component")
local modem = component.modem
if #args < 1 then
    print("Usage:")
    print("     multiWrapper replId toId startXYZ radXYZ toXYZ replicateNBT threads")
    print("     multiWrapper -9999 0 100,50,100 10,10,10 300,72,300 false 5")
    return
end
local threads = args[7]
local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
local function stringCoord(str)
    local pStr = split(str,",")
    return {tonumber(pStr[1]), tonumber(pStr[2]), tonumber(pStr[3])}
end
local start = stringCoord(args[3])
local radius = stringCoord(args[4])
local worldstart = stringCoord(args[5])
if math.floor(radius[2]/threads) ~= radius[2]/threads then error("Radius Y level is not smoothly dividable by threads.") end
for i=1,threads do
    modem.open(i) -- I LOVE STRING.FORMAT!!!
    print("Broadcasting to thread number "..i)
    modem.broadcast(i,string.format("%s %s %s,%s,%s %s,%s,%s %s,%s,%s %s",args[1],args[2],start[1],start[2]+((radius[2]/threads)*i),start[3],radius[1],radius[2]/threads,radius[3],worldstart[1],worldstart[2]+((radius[2]/threads)*i),worldstart[3],args[6]))
end