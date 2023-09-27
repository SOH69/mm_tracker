A Police Tracker Script to track a vehicle with the tracker.

## Discord
https://discord.gg/Au4uAT3frK

## Tebex Store
https://master-mind.tebex.io/

## Features
1. Configurable viewing range of tracker
2. Configurable Blip
3. Configurable Battery health of tracker
4. Configurable Number of tracker can be used at a time
5. Configurable tracker update interval

## Requirements
ox_lib

## Installation

Add this to qb-core -> shared -> items.lua
```lua
["tracker"] 					    = {["name"] = "tracker", 			 		       ["label"] = "Tracker", 					["weight"] = 500, 		   ["type"] = "item", 		  ["image"] = "tracker.png", 			     ["unique"] = false, 	     ["useable"] = true, 	  ["shouldClose"] = false,     ["combinable"] = nil,   ["description"] = ""},
```
Image Link: https://cdn.discordapp.com/attachments/1156592013534310432/1156596474386321511/tracker.png?ex=65158be8&is=65143a68&hm=57d35c4b614af2ac02580bd2b0ebaa1b13e744ff7a17da27cac19bafbcd4f90b&