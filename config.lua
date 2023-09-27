Config = Config or {}

Config.TimeLimit = 10  -- in minutes tracker life after use
Config.MaxLimit = 5 -- max number of trackers allowed
Config.TrackerRange = 500 -- range of tracker (gta distance)
Config.RefreshRate = 2 -- in seconds how much fast the tracker position is updated 

Config.Blip = {
    sprite = 225,
    color = 1,
    scale = 1.0,
    flash = true,
    flashrate = 1000
}

-- you need to have least knowlege of coding before changing anything below this line
if GetResourceState('ox_inventory') == 'started' then
    Config.Inventory = 'ox_inventory'
elseif GetResourceState('qb-inventory') == 'started' then
    Config.Inventory = 'qb-inventory'
else
    Config.Inventory = false
    warn('No Inventory found')
end