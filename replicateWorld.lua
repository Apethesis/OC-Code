local args = {...}
if #args < 1 then
    print("Usage:")
    print("     replicateWorld replId startXYZ radXYZ toXYZ")
    print("     replicateWorld -9999 100,50,100 10,10,10 300,72,300")
    return
end
local dc = component.debug
local replId = tonumber(args[1])
local world = dc.getWorld()
local parsed = {start = {}, radius = {}, worldstart = {}}
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
    local pStr = split(",",str)
    return {tonumber(pStr[1]), tonumber(pStr[2]), tonumber(pStr[3])}
end
parsed.start = stringCoord(args[1])
parsed.radius = stringCoord(args[2])
parsed.worldstart = stringCoord(args[3])
local blockQuant = 0
for x=parsed.start[1],parsed.start[1]+parsed.radius[1] do
    for y=parsed.start[2],parsed.start[2]+parsed.radius[2] do
        for z=parsed.start[3],parsed.start[3]+parsed.radius[3] do
            local _, type, block = dc.scanContentsAt(x,y,z,replId)
            if type ~= "EntityLivingBase" and type ~= "EntityMinecart" then
                blockQuant = blockQuant+1
                world.setBlock(parsed.worldstart[1]+(x-parsed.start[1]),parsed.worldstart[2]+(y-parsed.start[2]),parsed.worldstart[3]+(z-parsed.start[3]),block[1])
            end
        end
    end
end
print("Replicated "..blockQuant.." blocks into this world.")