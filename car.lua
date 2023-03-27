local class = require("classes/middleclass")
car = class("car")
local cars = {}
img = love.graphics.newImage("world/smoke.png")

-- =====================================================
-- LOADING CAR
function car:initialize(body,wheel,destructed,x,y, wheel1x,wheel1y,wheel2x,wheel2y, acceleration, maxSpeed)
    self.body = body or love.graphics.newImage("cars/car-full.png")
    self.wheel = wheel or love.graphics.newImage("cars/wheel.png")
    self.destructed = destructed or love.graphics.newImage("cars/car-destroyed.png")
    self.x = x or 200
    self.y = y or love.graphics.getHeight()
    self.w1x = wheel1x or 35
    self.w2x = wheel2x or 163
    
    self.w1y = wheel1y or 56
    self.w2y = wheel2y or 56
    self.wheel1x = self.x + self.w1x 
    self.wheel2x = self.x + self.w2x 
    self.wheel1y = self.y + self.w1y 
    self.wheel2y = self.y + self.w2y 
    self.destroyed = false
    self.enteredCar = false
    self.exploding = false
    self.smoke = love.graphics.newParticleSystem(img, 32)
    self.smoke:setParticleLifetime(2,5)
    self.smoke:setLinearAcceleration(-25, 0, 5, -100)
    self.smoke:setSpeed(-32)

    self.acceleration = acceleration or 5
    self.maxSpeed = maxSpeed or 200
    -- Add a self.smokeX and self.smokeY
    -- WHY? well because the smoke currently follows the player, prevent that!
    self.prompt = {
        text = "( F ) Enter Vehicle",
        x = 0,
        y = 0,
        visible = true
    }
    self.warning = {
        text = "You cannot exit the car at this speed",
        x = 0,
        y = 0,
        visible = false
    }
    self.crotation = 1
    self.timer = 0
    if self.y == love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.body:getHeight()
    end

    self.carExplosion = {}
    for i = 1,10,1 do
        self.carExplosion[i] = love.graphics.newImage("cars/explosion/"..i..".png")
    end
    self.carExplosionN = 1
    self.currentExplosion = self.carExplosion[self.carExplosionN]
	table.insert(cars, self)
	return self


end

-- ======================================================================
-- Update Car
function car:update(dt,bullets)
    self.wheel1x = self.x + self.w1x 
    self.wheel2x = self.x + self.w2x 
    self.wheel1y = self.y + self.w1y 
    self.wheel2y = self.y + self.w2y 
    self.smoke:update(dt)
    -- Updating prompt
    self.warning.x = self.x
    self.warning.y = self.y - 10

    if self.destroyed == false then
        self.prompt.text = "( F ) Enter Vehicle"
    else
        self.prompt.text = "( R ) Repair Vehicle"
    end

    -- Ability to blow up car
    for a,b in ipairs(bullets) do
        if b.x > self.x and b.x < self.x + self.body:getWidth() and b.y > self.y and b.y < self.y + self.body:getHeight() then
            if char.x > self.x and char.x < self.x + self.body:getWidth() and not allenteredCar() then
                return
            elseif self.destroyed == true then
                return
            elseif allenteredCar() then
                return
            else
                self.destroyed = true
                table.remove(bullets,a)
            end

        end
    end

     -- Car prompt
    if math.vdist(char.x,char.y,self.x,self.y) < 100 and not self.enteredCar then
        self.prompt.visible = true 
        self.prompt.x = self.x
        self.prompt.y = self.y - 30

    else
        self.prompt.visible = false
    end
    
    -- Setting car animation ( on destruction )
    if self.destroyed == true then
        self.exploding = true
        self.carExplosionN,self.currentExplosion = anim(self.carExplosion,self.carExplosionN,self.currentExplosion,dt, true)
        self.timer = self.timer + 1 * dt
        if self.timer > 1.7  and self.carExplosionN ~= 9 then
              self.carExplosionN = 9
        end
    else
        self.exploding = false
        self.timer = 0
    end



end

-- ========================================================================
-- DRAW | Split into three for corresponding drawing pattern

-- DRAW 1 | Drawing the actual Car
function car:draw()
    if self.destroyed == false then
        love.graphics.draw(self.body,self.x,self.y)
        love.graphics.draw(self.wheel,self.wheel1x,self.wheel1y,math.deg(self.crotation), 1, 1, self.wheel:getWidth()/2, self.wheel:getHeight()/2)
        love.graphics.draw(self.wheel,self.wheel2x,self.wheel2y,math.deg(self.crotation), 1, 1,  self.wheel:getWidth()/2,self.wheel:getHeight()/2)
    else
        love.graphics.draw(self.destructed,self.x,self.y)
        if self.exploding == true then
            love.graphics.draw(self.currentExplosion, self.x, self.y)
        end
        
    end
end 

-- DRAW 2 | Drawing the prompt
function car:draw2()
    if self.prompt.visible == true then

        love.graphics.setColor(0,0,0)
        love.graphics.print(self.prompt.text,self.prompt.x,self.prompt.y + 0.7)
        love.graphics.print(self.prompt.text,self.prompt.x,self.prompt.y - 0.7)
        love.graphics.print(self.prompt.text,self.prompt.x+ 0.7,self.prompt.y)
        love.graphics.print(self.prompt.text,self.prompt.x- 0.7,self.prompt.y)
        love.graphics.setColor(1,1,1)
        love.graphics.print(self.prompt.text,self.prompt.x,self.prompt.y)
        love.graphics.setColor(1,1,1)
    end
end 

-- DRAW 3 | Drawing the character
function car:draw3()
    if self.enteredCar == true then
        char.visible = false
        self.x = bodyX
        love.graphics.draw(self.smoke, self.x, self.y + self.body:getHeight())    
    elseif not allenteredCar()  then
        char.visible = true
    end
end 

-- =========================================
-- Actions on car

-- Move wheels forward and back
function car:wheelForward(dt)
    if self.enteredCar and char.speed > -70 then 
        if self.crotation < 360 then
            self.crotation = self.crotation  + char.speed/200 * dt
        else
            self.crotation = 1
        end
    else
        self.crotation = 1
    end
end

function car:wheelBackward(dt)
    if self.enteredCar and char.speed < 70 then
        if self.crotation > 1 then
            self.crotation = self.crotation  - ((-char.speed)/200) * dt
        else
            self.crotation = 360
        end
    else

        self.crotation = 360
        self:emitSmoke()
    end
end

function car:accelerate(dt)
    self:wheelForward(dt) -- Moving car wheels ( If in car ) [ RIGHT ]
    if char.speed < self.maxSpeed then
    if char.speed < ((75/100) * self.maxSpeed) then
        char.speed = char.speed + self.acceleration * 4 * dt
    else
        char.speed = char.speed + self.acceleration * dt
    end
    end
    if char.speed < 1 then
        char.speed = char.speed + self.acceleration * 10 * dt
    end
end

function car:retard(dt)
    self:wheelBackward(dt) -- Moving car wheels ( If in car ) [ LEFT ]
    if char.speed > 1 then
        char.speed = char.speed - (self.acceleration * 10) * dt
    else
        char.speed = char.speed - (self.acceleration/2) * dt
    end
end

function car:autoretard(dt)
    if self.enteredCar  then
        if char.speed > 1 then
            self:wheelForward(dt)
            char.speed = char.speed - self.acceleration * 10 * dt
        elseif char.speed < -1 then
            self:wheelBackward(dt)
            char.speed = char.speed + self.acceleration * 10 * dt
        else
            char.speed = 0
        end
    end
end
-- Enter car function
function car:enter()
    if self.enteredCar == false then
        self.enteredCar = true
        char.x = self.x
        char.speed = 0 
    else 
        if char.speed < 40 then
        self.enteredCar = false
        char.x = self.x + 50
        char.speed = 0 
        self.warning.visible = false
        else 
        self.warning.visible = true
        self.warning.x = self.x
        self.warning.y = self.y - 10
        end
    end

end

-- Instant destroy function
function car:destroy()
    self.destroyed = true
end
function car:fix()
    self.destroyed = false
end

-- ===============================================
-- Ease of access functions for car
function car:emitSmoke()
    local smk = self.smoke
    if smk ~= nil then
    smk:emit(10000)
    end
end


function car:distanceTo(obj)
    return math.vdist(obj.x,obj.y,self.x,self.y)
end

function car:isDestroyed()
   return self.destroyed
end

function car:entered()
    return self.enteredCar
end

function car:getX()
    return self.x 
end

function car:getY()
    return self.y 
end

-- ==============================================================
-- Entire entity checking
function uCars(dt,bullets) -- Update all cars
	for i, v in pairs(cars) do
		v:update(dt,bullets)
	end
end

function dCars1() -- Draw cars (1st Installment)
	for i, v in pairs(cars) do
		v:draw()
	end 
end
function dCars2() -- Draw cars (2nd Installment)
	for i, v in pairs(cars) do
		v:draw()
	end 
end
function dCars3() -- Draw cars (3rd Installment)
	for i, v in pairs(cars) do
		v:draw()
	end 
end
function allenteredCar() -- Combined checking function ( See if entered Car )
    for i, v in pairs(cars) do
        if v:entered() then
            return true
        end
    end 
    return false -- Return false if no cars have been entered
end

function allisDestroyed() -- Check if all cars are destroyed
    for i, v in pairs(cars) do
        if not v:isDestroyed() then
            return false -- Return false if at least one car is not destroyed
        end
    end 
    return true -- Return true if all cars are destroyed
end


function enterCorrespondingCar()
    local playerPos = char -- Assume this function returns the player's position
    local nearestCar = nil
    local nearestDist = math.huge
    for i, v in pairs(cars) do
        local dist = v:distanceTo(playerPos)
        if dist < 100 then
            if v:entered() then
                v:enter()
                return
            elseif not v:entered() and not allenteredCar() then
                if dist < nearestDist then
                    nearestCar = v
                    nearestDist = dist
                end
            end
        end
    end
    if nearestCar then
        nearestCar:enter()
    end
end
function fixCorrespondingCar() -- Enter nearest car
    local playerPos = char -- Assume this function returns the player's position
     local nearestCar = nil
     local nearestDist = math.huge
     for i, v in pairs(cars) do
         local dist = v:distanceTo(playerPos)
         if dist < 100 then
             if v.destroyed then
                 v:fix()
                 return
             elseif not v:entered() and not allenteredCar() then
                 if dist < nearestDist then
                     nearestCar = v
                     nearestDist = dist
                 end
             end
         end
     end
     if nearestCar then
         nearestCar:fix()
     end
end
-- Combined wheel movement for all Cars
function moveWheelsR(dt) -- Move wheel right
	for i, v in pairs(cars) do
        v:wheelForward(dt)
	end 
end
function moveWheelsL(dt) -- Move wheel left
    for i, v in pairs(cars) do
        v:wheelBackward(dt)
	end 
end
function accelerate(dt) -- Move wheel left
    for i, v in pairs(cars) do
    if v:entered() then
        v:accelerate(dt)
    end
	end 
end
function retard(dt) -- Move wheel left
    for i, v in pairs(cars) do
        v:retard(dt)
	end 
end
function autoretard(dt) -- Move wheel left
    for i, v in pairs(cars) do
        v:autoretard(dt)
	end 
end
