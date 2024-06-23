allowed_user_groups = {}
allowed_users = {}

local color_sequence = {
  { r = 1, g = 0, b = 0 }, -- Red
  { r = 1, g = 0.647, b = 0 }, -- Orange
  { r = 1, g = 1, b = 0 }, -- Yellow
  { r = 0, g = 1, b = 0 }, -- Green
  { r = 0, g = 0, b = 1 }, -- Blue
  { r = 0.63, g = 0.13, b = 1 }, -- Indigo
  { r = 1, g = 0.75, b = 1 }, -- Violet
}

local current_color_index = 1
local target_color_index = current_color_index + 1
local transition_progress = 0

function allow_user_group(group)
  if not tostring(group) then
    print('Group name must be a string! (' .. tostring(group) .. ')')
    return
  end

  if not table.HasValue(allowed_user_groups, group) then
    table.insert(allowed_user_groups, group)
  end
end

function allow_user(user)
  if not tostring(user) then
    print('SteamID must be a string! (' .. tostring(user) .. ')')
    return
  end

  if not table.HasValue(allowed_users, user) then
    table.insert(allowed_users, user)
  end
end

function linear_interpolation(a, b, t)
  return a + (b - a) * t
end

function color_loop()
  transition_progress = transition_progress + 0.175

  if transition_progress >= 1 then
    current_color_index = target_color_index
    target_color_index = (target_color_index % #color_sequence) + 1
    transition_progress = 0
  end

  local current_color = color_sequence[current_color_index]
  local target_color = color_sequence[target_color_index]
  local interpolated_color = {
    r = linear_interpolation(current_color.r, target_color.r, transition_progress),
    g = linear_interpolation(current_color.g, target_color.g, transition_progress),
    b = linear_interpolation(current_color.b, target_color.b, transition_progress),
  }

  for k, v in pairs(player.GetAll()) do
    if (table.HasValue(allowed_user_groups, v:GetUserGroup()) or table.HasValue(allowed_users, v:SteamID())) then
      v:SetWeaponColor(Vector(interpolated_color.r, interpolated_color.g, interpolated_color.b))
    end
  end
end

timer.Create("Color_timer", 0.2, 0, color_loop)
