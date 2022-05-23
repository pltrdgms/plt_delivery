- Orders will be the same for all players, once a person receives the order, it will no longer appear in the others.
- In the config, you can set the timing with which new orders will be placed, which items, how many pieces, price, duration and maximum number of orders will be ordered.
- If players mark, scrip will receive a notification for each new order.
- 0.00ms when out of use. 0.03 ms when in use.


* Its ready for ESX and QBCORE
- RegisterNetEvent('plt_delivery:Delivey')
* You can integrate it into your framework by editing the server event.

- TriggerEvent("plt_delivery:TakeOrders") 
* With the client side event, you can enable the UI to be opened from any other script you want.

function singleNotify(type,msg,time)
	exports['mythic_notify']:DoCustomHudText(type,msg,time)
end
* You can use it in your own notification system by changing its function.