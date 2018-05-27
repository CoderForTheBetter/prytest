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
  p = 0,
  r = 0,
  y = 0,
}


function Axis:on_step(_, dtime)  
  if self.p < 2.25 then
    self.p=self.p+0.01
    self.object:set_pitch(self.p)
    
  elseif self.r < 2.25 then
    self.r=self.r+0.01
    self.object:set_roll(self.r)
    
  elseif self.y < 2.25 then
    self.y=self.y+0.01
    self.object:set_yaw(self.y)
    
  else
    self.p = 0
    self.r = 0
    self.y = 0
    self.object:set_roll(self.r)
    self.object:set_pitch(self.p)
    self.object:set_yaw(self.y)
    
  end
  minetest.chat_send_all("Pitch: " .. tostring(self.p))
  minetest.chat_send_all("Roll: " .. tostring(self.r))
  minetest.chat_send_all("YAW: " .. tostring(self.y))
  minetest.chat_send_all(" ")
end




minetest.register_entity("prytest:axis", Axis)


minetest.register_chatcommand("spawn", {
	params = "<text>",
	description = "",
	func = function(name , text)
    if text == "axis" then
      minetest.get_player_by_name(name);
      local obj = minetest.add_entity(minetest.get_player_by_name(name):get_pos(), "prytest:axis")
    end
	end,
})
