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
  minetest.chat_send_all("Now use one of these commands:  /mode 45,  /mode spinX,  /mode spinY,  /mode spinZ,  /rotation x y z,  /help")
end


mode = ""

rotX = 0
rotY = 0
rotZ = 0


function Axis:on_step(_, dtime)  
  
  self.c = self.c + 1
  
  if mode == "45" then
    if self.c >= 50 and self.c <= 100 then
      rotX = 45
      rotY = 0
      rotZ = 0
    elseif self.c >= 100 and self.c <= 150 then
      rotX = 0
      rotY = 45
      rotZ = 0
    elseif self.c >= 150 and self.c <= 200 then
      rotX = 0
      rotY = 0
      rotZ = 45
    elseif self.c >= 200 then
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
                          "Commands:  /spawn axis,  /mode 45,  /mode spinX,  /mode spinY,  /mode spinZ,  /rotation x y z,  /help")
end




minetest.register_entity("rottest:axis", Axis)


minetest.register_chatcommand("spawn", {
	params = "<text>",
	description = "",
	func = function(name , text)
    if text == "axis" then
      minetest.get_player_by_name(name);
      local obj = minetest.add_entity(minetest.get_player_by_name(name):get_pos(), "rottest:axis")
    end
	end,
})

minetest.register_chatcommand("mode", {
	params = "<text>",
	description = "",
	func = function(name , text)
    mode = text
	end,
})


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

minetest.register_chatcommand("help", {
	params = "<text>",
	description = "",
	func = function(name , text)
    minetest.chat_send_all("Commands:  /spawn axis,  /mode 45,  /mode spinX,  /mode spinY,  /mode spinZ,  /rotation x y z,  /help")
	end,
})

minetest.register_on_joinplayer(function(player)
	minetest.chat_send_all("Commands:  /spawn axis,  /mode 45,  /mode spinX,  /mode spinY,  /mode spinZ,  /rotation x y z,  /help")
end)