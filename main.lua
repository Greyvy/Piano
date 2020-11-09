--[[
@TODO(Grey):
]]--

-- @NOTE(Grey): Debugging utility, it shows up in any web browser at the
-- address: http://127.0.0.1:8000/
lovebird = require "lovebird"

local game = {
    w=0,
    h=0,
}

local player = {
    x=0,
    y=0,
    acc_x=0,
    acc_y=0,
    vel_x=0,
    vel_y=0,
    radius=32,
    spd=1,
}

local keys = {}
local effect_names = {}

function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'p' then
        love.audio.play(play_sound)
    end
end

function sound_make(length, note)
    -- local c = 261.63
    local samples = math.floor(44100 * length)
    local sound_data = love.sound.newSoundData(samples)

    for i=0,samples do
        local t = (i / samples)
        local s = math.sin(t * math.pi * (length * note))
        sound_data:setSample(i, s)
    end

    return love.audio.newSource(sound_data)
end

function love.load()
    game.w, game.h = love.graphics.getDimensions()

    for i=1,8 do
        local k = {
            radius = 0,
            x = 0,
            y = 0,
            color = {1, 1, 1},
            sound = nil
        }

        k.radius = love.math.random(8, 64)
        k.x = love.math.random(k.radius, game.w - k.radius)
        k.y = love.math.random(k.radius, game.h - k.radius)
        k.color = {
            love.math.random(),
            love.math.random(),
            love.math.random()
        }

        local note = 110 + ((i - 1) * 5.5)
        k.sound = sound_make(0.5, note)

        keys[i] = k
    end

    for i=1,#keys do
        effect_names[i] = 'effect_'..i
    end


    player.x = game.w / 2
    player.y = game.h / 2
end

function love.update(dt)
    lovebird.update()
    lovebird.print(love.audio.setMixWithSystem(true))

    if love.keyboard.isDown("a") then
        player.acc_x = -player.spd
    end

    if love.keyboard.isDown("d") then
        player.acc_x = player.spd
    end

    if love.keyboard.isDown("w") then
        player.acc_y = -player.spd
    end

    if love.keyboard.isDown("s") then
        player.acc_y = player.spd
    end

    player.vel_x = player.vel_x + player.acc_x
    player.vel_y = player.vel_y + player.acc_y

    player.x = player.x + player.vel_x
    player.y = player.y + player.vel_y

    player.acc_x = 0
    player.acc_y = 0
    player.vel_x = player.vel_x * 0.95
    player.vel_y = player.vel_y * 0.95

    if (math.abs(player.vel_x) < 0.01) then
        player.vel_x = 0
    end

    if (math.abs(player.vel_y) < 0.01) then
        player.vel_y = 0
    end

    for i,k in pairs(keys) do
        k.hit = false

        local min_dist = player.radius + k.radius
        local dx = player.x - k.x
        local dy = player.y - k.y

        if dx * dx + dy * dy <= min_dist * min_dist then
            k.hit = true

            local random_num = love.math.random() * #effect_names
            local effect_name_index = 1 + math.floor(random_num)

            k.sound:setEffect(effect_names[effect_name_index])
            k.sound:play()
        end
    end
end

function love.draw()
    for _,k in pairs(keys) do
        if k.hit then
            love.graphics.setColor({1, 0, 0})
        else
            love.graphics.setColor(k.color)
        end
        love.graphics.circle("fill", k.x, k.y, k.radius)
    end

    love.graphics.setColor({1, 0, 1});
    love.graphics.circle("fill", player.x, player.y, player.radius);

    --[[
    -- @NOTE(Grey): Viz wave form
    love.graphics.setColor({1, 1, 1})
    love.graphics.push()
    love.graphics.translate(0, game.h / 2)

    local samples = 240  -- 44100
    for i=0,samples do
        local t = (i / samples)
        local s = math.sin(t * math.pi)

        local x = t * game.w
        local y = s * (game.h / 2)
        local w = game.w / samples
        local h = y

        love.graphics.rectangle("fill", x, -h, w, h)
    end
    love.graphics.pop()
    ]]--
end
