local class = require("classes/middleclass")
anim = class("anim")
local anims = {}

function anim:new(position,frames,x,y,rotation, sx, sy)
    self.position = position
    self.frames = frames
    
    self.x = x
    self.y = y
    self.r = rotation or 0
    self.sx = sx or 1
    self.sy = sy or self.sx
    self.table = {}
    for i = 1,self.frames,1 do
        self.table[i] = love.graphics.newImage(self.position..i..".png")
    end
    self.n = 1
    self.c = self.table[self.n]
    table.insert(anims, self)
	return self
end
function anim:play(playing, dt)
    local playing = playing or true
    if playing == true then 
    if self.n < #self.table then
        self.n = self.n + 8 * dt
        self.c = self.table[math.floor(self.n)]
    else
        self.n = 1
        self.c = self.table[self.n]
    end
    end
    return self.n,self.c
    
end

function anim:draw()
    love.graphics.draw(self.c, self.x, self.y,self.r,self.sx,self.sy) -- Making animation visible
end
function anim(table,inputN,currenttableval, dt, playing)
    local playing = playing or true
    if playing == true then 
    if inputN < #table then
        inputN = inputN + 8 * dt
        currenttableval = table[math.floor(inputN)]
    else
        inputN = 1
        currenttableval = table[inputN]
    end
    end
    return inputN,currenttableval

end

function loadAnim()
    walk = {}
    for i = 1,4,1 do
        walk[i] = love.graphics.newImage("characters/"..character.."/walk/"..i..".png")
    end
    walkN = 1
    currentWalkAnim = walk[walkN]

    jump = {}
    for i = 1,1,1 do
        jump[i] = love.graphics.newImage("characters/"..character.."/jump/"..i..".png")
    end
    jumpN = 1
    currentJumpAnim = jump[jumpN]

    gunwalk = {}
    for i = 1,2,1 do
        gunwalk[i] = love.graphics.newImage("characters/"..character.."/gunwalk/"..i..".png")
    end
    gunwalkN = 1
    currentgunWalkAnim = gunwalk[gunwalkN]

    gunshoot = {}
    for i = 1,3,1 do
        gunshoot[i] = love.graphics.newImage("characters/"..character.."/shoot/"..i..".png")
    end
    gunshootN = 1
    currentgunshoot = gunshoot[gunshootN]

end

function newBullet()
    bullet = {}
    if char.direction == "left" then bullet.d = -1 else bullet.d = 1 end
    bullet.x = (char.x + body:getWidth() * bullet.d) - 10 * bullet.d
    bullet.y = char.y + 30 
    bullet.speedx = 300
    table.insert(bullets,bullet)
   return(bullet)
end

function bulletD()
 return bullet.d
end

--[[local class = require("classes/middleclass")
anim16 = class("anim")
local anim16s = {}

function anim16:initialize(position,frames,x,y,rotation, sx, sy)
    self.position = position
    self.frames = frames
    
    self.x = x
    self.y = y
    self.r = rotation or 0
    self.sx = sx or 1
    self.sy = sy or 1
    self.table = {}
    for i = 1,self.frames,1 do
        self.table[i] = love.graphics.newImage(self.position..i..".png")
    end
    self.n = 1
    self.c = self.table[self.n]
    table.insert(anim16s, self)
	return self
end
function anim16:play(playing, dt)
    local playing = playing or true
    if playing == true then 
    if self.n < #self.table then
        self.n = self.n + 8 * dt
        self.c = self.table[math.floor(self.n)]
    else
        self.n = 1
        self.c = self.table[self.n]
    end
    end
    return self.n,self.c
    
end
function anim16:update(x, y, r, sx, sy)
    
    self.x = x
    self.y = y
    self.r = r
    self.sx = sx
    self.sy = sy
end
function anim16:draw()
    love.graphics.draw(self.c, self.x, self.y,self.r,self.sx,self.sy) -- Making animation visible
end
function anim(table,inputN,currenttableval, dt, playing)
    local playing = playing or true
    if playing == true then 
    if inputN < #table then
        inputN = inputN + 8 * dt
        currenttableval = table[math.floor(inputN)]
    else
        inputN = 1
        currenttableval = table[inputN]
    end
    end
    return inputN,currenttableval

end

function loadAnim()

    walk = anim16:new("characters/"..character.."/walk/",4,char.x,char.y,rotation, flipped, 1)
    jump = anim16:new("characters/"..character.."/jump/",1,char.x,char.y,rotation, flipped, 1)
    gunwalk = anim16:new("characters/"..character.."/gunwalk/",2,char.x,char.y,rotation, flipped, 1)
    gunshoot = anim16:new("characters/"..character.."/shoot/",3,char.x,char.y,rotation, flipped, 1)

end

function newBullet()
    bullet = {}
    if char.direction == "left" then bullet.d = -1 else bullet.d = 1 end
    bullet.x = (char.x + body:getWidth() * bullet.d) - 10 * bullet.d
    bullet.y = char.y + 30 
    bullet.speedx = 300
    table.insert(bullets,bullet)
   return(bullet)
end

function bulletD()
 return bullet.d
end]]