local Axis = {
  hp_max = 1,
  physical = true,
  weight = 50,
  collisionbox = {-1.5, 0, -1.5, 1.5, 1.5, 1.5},
  visual = "mesh",
  visual_size = {x=12, y=12,},
  mesh = "axis.x",
  textures = {"axis.png"}, -- number of required textures depends on visual
  colors = {}, -- number of required colors depends on visual
  spritediv = {x=1, y=1},
  initial_sprite_basepos = {x=0, y=0},
  is_visible = true,
  makes_footstep_sound = false,
  automatic_rotate = false,
  c = 0,
}


function Axis:on_activate(_, staticdata)
  minetest.chat_send_all("Commands:  /spawn axis,  /spawn box  /mode 45,  /mode spinX,  /mode spinY,  /mode spinZ,  /rotation <x> <y> <z> (negative does not work due to my lua code, sorry, use setRot),  /setRotX <x>,  /setRotY <y>,  /setRotZ [z]  /help,  /attach ab,  /attach ba")
end


mode = ""

rotX = 0
rotY = 0
rotZ = 0


function Axis:on_step(_, dtime)  
  
  self.c = self.c - (1/10)
  
  if mode == "45" then
    if self.c >= 50/10 and self.c <= 100/10 then
      rotX = 4/math.pi
      rotY = 0
      rotZ = 0
    elseif self.c >= 100/10 and self.c <= 150/10 then
      rotX = 0
      rotY = 4/math.pi
      rotZ = 0
    elseif self.c >= 150/10 and self.c <= 200/10 then
      rotX = 0
      rotY = 0
      rotZ = 4/math.pi
    elseif self.c >= 200/10 then
      self.c = 0
      rotX = 0
      rotY = 0
      rotZ = 0
    end
    self.object:set_rotation({x=rotX, y=rotY, z=rotZ})
  elseif mode == "spinX" then
    self.object:set_rotation({x=self.c, y=0, z=0})
    
  elseif mode == "spinY" then
    self.object:set_rotation({x=0, y=self.c, z=0})
    
  elseif mode == "spinZ" then
    self.object:set_rotation({x=0, y=0, z=self.c})
    
  elseif mode == "rotate" then
    self.object:set_rotation({x=rotX, y=rotY, z=rotZ})
    
  end
  minetest.chat_send_all(" ")
  minetest.chat_send_all(" ")
  minetest.chat_send_all(" ")
  minetest.chat_send_all(" ")
  minetest.chat_send_all(" ")
  minetest.chat_send_all( "Rot X: " .. tostring(self.object:get_rotation().x) .. "   " ..
                          "Rot Y: " .. tostring(self.object:get_rotation().y) .. "   " ..
                          "Rot Z: " .. tostring(self.object:get_rotation().z) .. "       " ..
                          "Commands:  /spawn axis,  /spawn box  /mode 45,  /mode spinX,  /mode spinY,  /mode spinZ,  /rotation <x> <y> <z> (negative does not work due to my lua code, sorry, use setRot),  /setRotX <x>,  /setRotY <y>,  /setRotZ [z]  /help,  /attach ab,  /attach ba")
end


local Box = {
  hp_max = 1,
  physical = true,
  weight = 50,
  collisionbox = {-1.5, 0, -1.5, 1.5, 1.5, 1.5},
  visual = "mesh",
  visual_size = {x=12, y=12,},
  mesh = "box.x",
  textures = {"unwrap_helper.jpg"}, -- number of required textures depends on visual
  colors = {}, -- number of required colors depends on visual
  spritediv = {x=1, y=1},
  initial_sprite_basepos = {x=0, y=0},
  is_visible = true,
  makes_footstep_sound = false,
  automatic_rotate = false,
  s = 0,
}


function Box:on_step(_, dtime) 
  self.s = self.s + 0.1
  self.object:set_rotation({x=0, y=self.s, z=0})
end




minetest.register_entity("prytest:axis", Axis)
minetest.register_entity("prytest:box", Box)


local lastAxis = nil
local lastBox = nil


minetest.register_chatcommand("spawn", {
	params = "<text>",
	description = "",
	func = function(name , text)
    if text == "axis" then
      lastAxis = minetest.add_entity(minetest.get_player_by_name(name):get_pos(), "prytest:axis")
    elseif text == "box" then
      lastBox = minetest.add_entity(minetest.get_player_by_name(name):get_pos(), "prytest:box")
    end
	end,
})


minetest.register_chatcommand("attach", {
	params = "<text>",
	description = "",
	func = function(name , text)
    if text == "ab" then
      lastBox:set_attach(lastAxis, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
      lastBox:set_properties({visual_size = {x=0.6, y=0.6}})
    elseif text == "ba" then
      lastAxis:set_attach(lastBox, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
      lastAxis:set_properties({visual_size = {x=0.6, y=0.6}})
    end
	end,
})



-- can set to various modes
minetest.register_chatcommand("mode", {
	params = "<text>",
	description = "",
	func = function(name , text)
    mode = text
	end,
})


-- This one does not work with negative numbers due to Lua patterns
minetest.register_chatcommand("rotation", {
	params = "<x> <y> <z>",
	description = "Apply rotation to axis entity",
  privs = {privs=true},
	func = function(name, param)
    axes = {}
    for axis in param:gmatch("%w+") do 
      table.insert(axes, axis) 
    end
    if axes[1] == nil or axes[2] == nil or axes[3] == nil then
      minetest.chat_send_player(name, "The form of the command is: /rotation <x> <y> <z>")
    else
      rotX = tonumber(axes[1])
      rotY = tonumber(axes[2])
      rotZ = tonumber(axes[3])
      mode = "rotate"
    end
	end
})


minetest.register_chatcommand("setRotX", {
	params = "<x>",
	description = "Apply rotation x",
  privs = {privs=true},
	func = function(name, param)
    rotX = tonumber(param)
    mode = "rotate"
	end
})

minetest.register_chatcommand("setRotY", {
	params = "<y>",
	description = "Apply rotation y",
  privs = {privs=true},
	func = function(name, param)
    rotY = tonumber(param)
    mode = "rotate"
	end
})

minetest.register_chatcommand("setRotZ", {
	params = "<z>",
	description = "Apply rotation z",
  privs = {privs=true},
	func = function(name, param)
    rotZ = tonumber(param)
    mode = "rotate"
	end
})


minetest.register_chatcommand("help", {
	params = "<text>",
	description = "",
	func = function(name , text)
    minetest.chat_send_all("Commands:  /spawn axis,  /spawn box  /mode 45,  /mode spinX,  /mode spinY,  /mode spinZ,  /rotation <x> <y> <z> (negative does not work due to my lua code, sorry, use setRot),  /setRotX <x>,  /setRotY <y>,  /setRotZ [z]  /help,  /attach ab,  /attach ba")
	end,
})

minetest.register_on_joinplayer(function(player)
	minetest.chat_send_all("Commands:  /spawn axis,  /spawn box  /mode 45,  /mode spinX,  /mode spinY,  /mode spinZ,  /rotation <x> <y> <z> (negative does not work due to my lua code, sorry, use setRot),  /setRotX <x>,  /setRotY <y>,  /setRotZ [z]  /help,  /attach ab,  /attach ba")
end)