plt_delivery = {} local PLT = plt_delivery
---------------------------------------------------------------------------------------------------------------------------------------------------------
PLT.U = Lang["EN"]                                              -- SET = ("EN" or "TR" or "Custom"), Edit locale.lua to add more languages.
PLT.MaxOrder = 50
PLT.NewOrderTime = 20 * 1
PLT.DeliveryItems = {
    ["water"]     = {label = "Water",     price = 20, minMaxAmount ={1,9}, orderDensity = 20, timeToCancel=60*30},
    ["bread"]     = {label = "Bread",     price = 40, minMaxAmount ={1,5}, orderDensity = 15, timeToCancel=60*60*3},
    ["hamburger"] = {label = "Hamburger", price = 60, minMaxAmount ={1,3}, orderDensity = 50, timeToCancel=60*50},
    ["chocolate"] = {label = "Chocolate", price = 10, minMaxAmount ={5,15},orderDensity = 20, timeToCancel=60*40},
    ["beer"]      = {label = "Beer",      price = 90, minMaxAmount ={1,9}, orderDensity = 30, timeToCancel=60*70},
}

PLT.TotalPercent = 0
for k,v in pairs(PLT.DeliveryItems) do
    v.minPercent = PLT.TotalPercent
    v.maxPercent = v.minPercent+ v.orderDensity
    PLT.TotalPercent  = v.maxPercent
end
