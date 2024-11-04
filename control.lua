local rand = math.random

local waters = {
  clean = { ["water"] = true, ["deepwater"] = true },
  green = { ["water-green"] = true, ["deepwater-green"] = true },
  mud = { ["water-mud"] = true, ["water-shallow"] = true },
  wube = { ["water-wube"] = true },
}

script.on_configuration_changed(function()
  storage.corpses = {}
end)

script.on_init(function()
  storage.corpses = storage.corpses or {}
end)

local function ripple_at_position(p, surface)
  local r = 2.5
  local area = { { p.x - r, p.y - r }, { p.x + r, p.y + r } } -- Do the math once
  local tile = surface.get_tile(p)
  if not tile or not tile.valid then return end
  local tilename = tile.name
  if waters.clean[tilename] then
    if surface.count_tiles_filtered { area = area, name = "water", limit = 25 } +
        surface.count_tiles_filtered { area = area, name = "deepwater", limit = 25 } >= 25
    then
      surface.create_entity { name = "water-ripple" .. rand(1, 4) .. "-smoke", position = p }
      return true
    end
  elseif waters.green[tilename] then
    if surface.count_tiles_filtered { area = area, name = "water-green", limit = 25 } +
        surface.count_tiles_filtered { area = area, name = "deepwater-green", limit = 25 } >= 25
    then
      surface.create_entity { name = "greenwater-ripple" .. rand(1, 4) .. "-smoke", position = p }
      return true
    end
  elseif waters.mud[tilename] then
    if surface.count_tiles_filtered { area = area, name = "water-shallow", limit = 25 } +
        surface.count_tiles_filtered { area = area, name = "water-mud", limit = 25 } >= 25
    then
      surface.create_entity { name = "mudwater-ripple" .. rand(1, 4) .. "-smoke", position = p }
      return true
    end
  elseif waters.wube[tilename] then
    if surface.count_tiles_filtered { area = area, name = "water-wube", limit = 25 } >= 25
    then
      surface.create_entity { name = "water-ripple" .. rand(1, 4) .. "-smoke", position = p }
      return true
    end
  end
end

local function do_the_ripple(player)
  ripple_at_position(player.character.position, player.surface)
end

script.on_event(defines.events.on_tick, function(event)
  if event.tick % 60 == 0 then
    -- Ripple for players in water
    local vfx_for_vehicles = settings.global["Noxys_Swimming-vfx-for-vehicles"].value
    for _, player in pairs(game.connected_players) do
      if player.character and (player.vehicle == nil or vfx_for_vehicles) then
        do_the_ripple(player)
      end
    end
  end
end)

script.on_event(defines.events.on_player_changed_position, function(e)
  local player = game.players[e.player_index]
  if not player.character then return end
  local vfx_for_vehicles = settings.global["Noxys_Swimming-vfx-for-vehicles"].value
  if player.vehicle ~= nil and not vfx_for_vehicles then return end
  local position = player.character.position
  local oldpos = storage.lastposition
  if oldpos == nil then oldpos = { x = 0, y = 0 } end
  if position.x == oldpos.x and position.y == oldpos.y then return end
  storage.lastposition = position
  local tile = player.surface.get_tile(position)
  if tile.valid then
    do_the_ripple(player)
    if waters.clean[player.surface.get_tile(position).name] then
      player.surface.create_entity { name = "water-splash-smoke", position = position }
    elseif waters.green[player.surface.get_tile(position).name] then
      player.surface.create_entity { name = "greenwater-splash-smoke", position = position }
    end
  end
end)

script.on_event(defines.events.on_post_entity_died, function(event)
  for _, v in pairs(event.corpses) do
    if ripple_at_position(v.position, v.surface) then
      v.destroy()
    end
  end
end)
