require('classes/car')
function accelerateVehicle(dt)
    if not allenteredCar() then
        char.x = char.x + 100 * dt
    else
        accelerate(dt)
    end
end

function retardVehicle(dt)
    if not allenteredCar() then
        char.x = char.x - 100 * dt
    else
        retard(dt)
    end    
end
function autoRetard(dt)
    autoretard(dt)
end
