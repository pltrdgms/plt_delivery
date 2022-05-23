PLT = plt_delivery
U = PLT.U
ESX = nil
QBCore = nil
PlayersUsedUi = {}
PlayerWantsNotify = {}
Orders = {}
LastOrderTime = 0

Citizen.CreateThread(function(...) 
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  if ESX == nil then Citizen.Wait(500) TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)   end 
  if ESX == nil then QBCore = exports['qb-core']:GetCoreObject()  end
end)


RegisterNetEvent('plt_delivery:Delivey')
AddEventHandler('plt_delivery:Delivey', function(info)
  local src = source
  if Orders[info.orderId] == nil then singleNotify(src,"error",U["error"],5000)  return end
  if ESX ~= nil then
    local xPlayer  = ESX.GetPlayerFromId(src)
    if xPlayer ~= nil then
        local total = xPlayer.getInventoryItem(info.name).count
        if total and total >= info.amount then
          xPlayer.removeInventoryItem(info.name, info.amount)	
          singleNotify(src,"inform","-"..info.amount.."x "..info.name,5000) 
          xPlayer.addMoney(info.amount*PLT.DeliveryItems[info.name].price)
          singleNotify(src,"success","+"..(info.amount*PLT.DeliveryItems[info.name].price).."$",5000) 
           Orders[info.orderId] = nil 
        else
          singleNotify(src,"error",U["dont_have"]..info.amount.."x "..info.label,5000)
          Orders[info.orderId].source = nil
        end  
    else
      Orders[info.orderId].source = nil
    end
  elseif QBCore ~= nil then 
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local xitem = xPlayer.Functions.GetItemByName(info.name)
    if xitem then 
      local total = xitem.amount
      if total and total >= info.amount then
        xPlayer.Functions.RemoveItem(info.name, info.amount)
        singleNotify(src,"inform","-"..info.amount.."x "..info.name,5000) 
        xPlayer.Functions.AddMoney('bank', (info.amount*PLT.DeliveryItems[info.name].price))
        singleNotify(src,"success","+"..(info.amount*PLT.DeliveryItems[info.name].price).."$",5000) 
         Orders[info.orderId] = nil 
      else
        singleNotify(src,"error",U["dont_have"]..info.amount.."x "..info.label,5000)
        Orders[info.orderId].source = nil
      end
    else
      singleNotify(src,"error",U["dont_have_any"]..info.label,5000)
      Orders[info.orderId].source = nil
    end
  end
end)

AddEventHandler('playerDropped', function (reason)
  local src = source
  for k,v in pairs(Orders)do
    if v.source == src then
      v.source = nil
    end
  end
end)

Citizen.CreateThread(function(...) 
  local id = 1
  while true do Citizen.Wait(1000)
    if tableNum(Orders) < PLT.MaxOrder and PLT.NewOrderTime + LastOrderTime < os.time() then 
      local orderPercentage = math.random(0,PLT.TotalPercent)
      for k,v in pairs(PLT.DeliveryItems) do  Citizen.Wait(0)
        if orderPercentage > v.minPercent and orderPercentage <= v.maxPercent then 
          Orders[id] =  {
            orderId=id,
            name=k,
            label=v.label,
            coord=PLT.DoorsCoordinate[math.random(1,#PLT.DoorsCoordinate)],
            amount=math.random(v.minMaxAmount[1],v.minMaxAmount[2]),
            cancelTime = os.time()+v.timeToCancel
          }
          SendNewOrderNotify(Orders[id])
          id=id+1
          LastOrderTime = os.time()
          updateUi()
          break
        end
      end
    else
      local now = os.time()
      for k,v in pairs(Orders) do Citizen.Wait(0)
        if now > v.cancelTime  then
          if v.source ~= nil then 
            singleNotify(v.source,"error",U["too_late"],5000) 
            TriggerClientEvent("plt_delivery:CancelOrder",v.source)
          end
          Orders[k] = nil 
        end
      end
    end
  end
end)

RegisterNetEvent('plt_delivery:SendMeOrders')
AddEventHandler('plt_delivery:SendMeOrders', function()
  local src = source
  TriggerClientEvent("plt_delivery:OpenOrders",src,Orders,os.time())
  PlayersUsedUi[src] = true
end)


RegisterNetEvent('plt_delivery:NewOrderNotify')
AddEventHandler('plt_delivery:NewOrderNotify', function(value)
  local src = source
  if value then
    PlayerWantsNotify[src] = value
    singleNotify(src,"success",U["notify_on"],5000) 
  else
    PlayerWantsNotify[src] = nil
    singleNotify(src,"error",U["notify_off"],5000) 
  end
end)

RegisterNetEvent('plt_delivery:CanIOrder')
AddEventHandler('plt_delivery:CanIOrder', function(id)
  local src = source
  PlayersUsedUi[src] = nil
  if Orders[id] == nil then singleNotify(src,"error",U["error"],5000)  return end
  if Orders[id].source then singleNotify(src,"error",U["other_guy_take"],5000)  return end
  if OnAnyOrder(src) then  singleNotify(src,"error",U["you_have_already"],5000) return end
    Orders[id].source = src
    singleNotify(src,"inform",U["taked_order"],5000) 
    TriggerClientEvent("plt_delivery:GetOrder",src,Orders[id])
end)



RegisterNetEvent('plt_delivery:ImTurnoffui')
AddEventHandler('plt_delivery:ImTurnoffui', function()
  PlayersUsedUi[source] = nil
end)

RegisterNetEvent('plt_delivery:GetMeCoordForshow')
AddEventHandler('plt_delivery:GetMeCoordForshow', function(id)
  local src = source
  PlayersUsedUi[src] = nil
  TriggerClientEvent("plt_delivery:ShowCoords",src,Orders[id].coord)
end)


RegisterNetEvent('plt_delivery:CancelOrder')
AddEventHandler('plt_delivery:CancelOrder', function(id)
  local src = source
  Orders[id].source = nil
  TriggerClientEvent("plt_delivery:OpenOrders",src,Orders,os.time())
end)

function updateUi()
  for k,v in pairs(PlayersUsedUi) do
    TriggerClientEvent("plt_delivery:OpenOrders",k,Orders,os.time())
  end
end
function SendNewOrderNotify(data)
  for k,v in pairs(PlayerWantsNotify) do
    singleNotify(k,"inform",U["new_order"]..data.amount.."x "..data.label.." for "..(data.amount*PLT.DeliveryItems[data.name].price).."$",5000)
  end
end
function dump(o) if type(o) == 'table' then local s = '{ '  for k,v in pairs(o) do if type(k) ~= 'number' then k = '"'..k..'"' end s = s .. '['..k..'] = ' .. dump(v) .. ','   end return s .. '} ' else    return tostring(o)  end end
function tableNum(table) local t = 0 if type(table) ~= 'table' then return t end for k,v in pairs(table) do t = t + 1 end return t end
function OnAnyOrder(src) for k,v in pairs(Orders) do if v.source == src then return true end end return false end
function singleNotify(src,type,message,time)   TriggerClientEvent('plt_delivery:SendNotify', src, type,message,time) end

