local args = {...}
if #args < 1 then
    print("Usage:")
    print("     replicateWorld replId toId startXYZ radXYZ toXYZ replicateNBT")
    print("     replicateWorld -9999 0 100,50,100 10,10,10 300,72,300 false")
    return
end
local dc = require("component").debug
local replWorld = dc.getWorld(tonumber(args[1]))
local world = dc.getWorld(tonumber(args[2]))
local replNBT = args[6]
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
    local pStr = split(str,",")
    return {tonumber(pStr[1]), tonumber(pStr[2]), tonumber(pStr[3])}
end
parsed.start = stringCoord(args[3])
parsed.radius = stringCoord(args[4])
parsed.worldstart = stringCoord(args[5])
print("Clearing area for replication...")
world.setBlocks(parsed.worldstart[1],parsed.worldstart[2],parsed.worldstart[3],parsed.worldstart[1]+parsed.radius[1],parsed.worldstart[2]+parsed.radius[2],parsed.worldstart[3]+parsed.radius[3],"minecraft:air",0)
print("Cleared area")
print(string.format("Starting replication at %s, %s, %s",parsed.worldstart[1],parsed.worldstart[2],parsed.worldstart[3]))
local blockQuant = 0
local startTime = os.time()
for y=parsed.start[2],parsed.start[2]+parsed.radius[2] do
    for x=parsed.start[1],parsed.start[1]+parsed.radius[1] do
        for z=parsed.start[3],parsed.start[3]+parsed.radius[3] do
            local block, meta = replWorld.getBlockId(x,y,z), replWorld.getMetadata(x,y,z)
            local dx, dy, dz = parsed.worldstart[1]+(x-parsed.start[1]),parsed.worldstart[2]+(y-parsed.start[2]),parsed.worldstart[3]+(z-parsed.start[3])
            local nbt
            if replNBT then nbt = replWorld.getTileNBT(x,y,z) end
            if block ~= 0 then
                blockQuant = blockQuant+1
                world.setBlock(dx,dy,dz,block,meta)
                if replNBT then world.setTileNBT(dx,dy,dz,nbt) end
            end
        end
    end
end
local endTime = os.time()
print("Replicated "..blockQuant.." blocks into this world.")
print(string.format("Took %ss at %sb/s",endTime-startTime,(endTime-startTime)/blockQuant))