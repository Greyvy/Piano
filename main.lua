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

local keys = {
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
    {x=0, y=0, radius=16, color={255, 255, 255}, hit=false, sound=nil},
}

awful_sound = nil
play_sound = nil

function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'p' then
        love.audio.play(play_sound)
    end
end

function sound_make(length, note)
    local n = note -- 261.63
    local number_of_seconds = length
    local samples = 44100 * number_of_seconds
    local sound_data = love.sound.newSoundData(samples)

    for i=0,samples do
        local t = (i / samples)
        local s = math.sin(t * math.pi * (number_of_seconds * n))
        sound_data:setSample(i, s)
    end

    return love.audio.newSource(sound_data)
end

function love.load()
    game.w, game.h = love.graphics.getDimensions()

    for i,k in pairs(keys) do
        k.radius = love.math.random(8, 64)
        k.x = love.math.random(k.radius, game.w - k.radius)
        k.y = love.math.random(k.radius, game.h - k.radius)
        --[[
        local x_step = (game.w - (k.radius * 2)) / 8
        k.radius = 16
        k.x = k.radius + ((i % 8) * x_step)
        k.y = k.radius + (math.floor(i / 8) * x_step)
        ]]--
        k.color[1] = love.math.random()
        k.color[2] = love.math.random()
        k.color[3] = love.math.random()

        local note = 110 + ((i - 1) * 5.5)
        k.sound = sound_make(0.5, note)
    end

    player.x = game.w / 2
    player.y = game.h / 2
end

function love.update(dt)
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


    for _,k in pairs(keys) do
        k.hit = false

        local min_dist = player.radius + k.radius
        local dx = player.x - k.x
        local dy = player.y - k.y

        if dx * dx + dy * dy <= min_dist * min_dist then
            k.hit = true

            love.audio.play(k.sound)
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

    --[[
    love.graphics.setColor({1, 1, 1});
    love.graphics.print(player.vel_x, 8, 8)
    love.graphics.print(player.vel_y, 8, 20)

    local y_off = 20 + 12
    for i,k in pairs(keys) do
        local y_block_off = (i - 1) * (12 * 3)
        love.graphics.print(k.color[1], 8, y_off + y_block_off + 0)
        love.graphics.print(k.color[2], 8, y_off + y_block_off + 12)
        love.graphics.print(k.color[3], 8, y_off + y_block_off + 24)
    end
    ]]--
end
