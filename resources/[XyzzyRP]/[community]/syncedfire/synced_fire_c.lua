local fireModel = 8501
function applyFire()
	local fire = engineLoadDFF("fire.dff",8501)
	engineReplaceModel(fire,fireModel)
end

addEventHandler("onClientResourceStart",resourceRoot,applyFire)

function createExtinguisher(wep,_,_,hitX,hitY,hitZ)
	if wep == 42 and math.random(1,10)==1 then
	for k, v in ipairs(getElementsByType("object",resourceRoot)) do
		if getElementModel(v) == fireModel then
			local fX,fY,fZ = getElementPosition(v)
			local dist = getDistanceBetweenPoints2D(hitX,hitY,fX,fY)
			if dist < 1 then
				triggerServerEvent("fireExtinguished",localPlayer,v)
			end
		end
	end
	end
	if wep == 37 and math.random(1,5)==1 then	-- tworzymy ogien!
	  triggerServerEvent("doCreateFire", root, hitX, hitY, hitZ, getElementDimension(localPlayer), getElementInterior(localPlayer))
	end
end


addEventHandler("onClientPlayerWeaponFire",localPlayer,createExtinguisher)
--[[
function enterTruck(veh,seat)
	if getElementModel(veh) ~= 407 or seat > 0 then return end
	if not rendering then
]]--

function enterTruck(veh,seat)
	if getElementModel(veh) ~= 407 or seat > 0 then return end
	if not rendering then
      addEventHandler("onClientRender",root,checkTurret)
    end
end

addEventHandler("onClientPlayerVehicleEnter",localPlayer,enterTruck)

function exitTruck()
if rendering then
  removeEventHandler("onClientRender",root,checkTurret)
end
end

addEventHandler("onClientPlayerVehicleExit",localPlayer,exitTruck)
addEventHandler("onClientPlayerWasted",localPlayer,exitTruck)
function checkTurret()
  if not getControlState("vehicle_fire") and not getControlState("vehicle_secondary_fire") then return end

  local veh = getPedOccupiedVehicle(localPlayer)
  if not veh then return end
  local fX,fY,fZ = getElementPosition(veh)
  local turretPosX,turretPosY = getVehicleTurretPosition(veh)
  local turretPosX = math.deg(turretPosX)
  if turretPosX < 0 then turretPosX = turretPosX+360 end
  local rotX,rotY,rotZ = getVehicleRotation(veh)
  local turretPosX = turretPosX+rotZ-360
  if turretPosX < 0 then turretPosX = turretPosX+360 end
--  outputDebugString(fX.."x"..fY)
--  local firetruckShape = createColSphere(fX,fY,fZ,20)

--  local burningVehicles = getElementsWithinColShape(firetruckShape,"object")
--  outputDebugString("elementow "..#burningVehicles)
  local burningVehicles=getElementsByType("object", resourceRoot, true)
  for k, v in pairs(burningVehicles) do
      local bX,bY,bZ = getElementPosition(v)
      if getDistanceBetweenPoints2D(bX,bY,fX, fY)<30 then 
        local neededRot = findRotation(fX,fY,bX,bY)
        if turretPosX > neededRot-10 and turretPosX < neededRot+10 and math.random(1,25)==1 then
          triggerServerEvent("fireExtinguished",localPlayer,v)
          break
        end
      end                                                          
  end
--  destroyElement(firetruckShape)
end




function findRotation(x1,y1,x2,y2)