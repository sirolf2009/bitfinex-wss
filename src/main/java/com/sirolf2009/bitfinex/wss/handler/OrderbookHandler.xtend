package com.sirolf2009.bitfinex.wss.handler

import com.google.common.eventbus.EventBus
import com.google.common.eventbus.Subscribe
import com.google.gson.JsonArray
import com.sirolf2009.commonwealth.trading.orderbook.ILimitOrder
import com.sirolf2009.commonwealth.trading.orderbook.LimitOrder
import com.sirolf2009.commonwealth.trading.orderbook.Orderbook
import java.util.HashMap
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtend.lib.annotations.ToString

@FinalFieldsConstructor class OrderbookHandler {

	val EventBus eventBus
	val Map<Double, MutableOrder> orderbook = new HashMap()

	@Subscribe def void onData(JsonArray array) {
		if(array.get(1).jsonArray) {
			val data = array.get(1).getAsJsonArray()
			(0 ..< data.size()).map[data.get(it).asJsonArray].map [ order |
				try {
					new MutableOrder() => [
						price = order.get(0).asDouble
						count = order.get(1).asInt
						amount = order.get(2).asDouble
					]
				} catch(Exception e) {
					throw new RuntimeException("Failed to handle " + order, e)
				}
			].forEach [
				orderbook.put(price, it)
			]
			postOrderbook()
		} else if(array.size() == 4) {
			val price = array.get(1).asDouble
			val count = array.get(2).asInt
			val amount = array.get(3).asDouble
			synchronized(orderbook) {
				if(count == 0) {
					orderbook.remove(price)
				} else if(orderbook.containsKey(price)) {
					val order = orderbook.get(price)
					order.count = count
					order.amount = amount
				} else {
					orderbook.put(price, new MutableOrder() => [
						it.price = price
						it.count = count
						it.amount = amount
					])
				}
			}
			postOrderbook()
		}
	}

	def postOrderbook() {
		synchronized(orderbook) {
			val orders = orderbook.values.groupBy[amount > 0]
			val asks = orders.get(false).map[immutable].toSet().toList()
			val bids = orders.get(true).map[immutable].toSet().toList()
			eventBus.post(new Orderbook(asks, bids))
		}
	}

	@EqualsHashCode @ToString @Accessors static class MutableOrder {
		var double price
		var int count
		var double amount

		def immutable() {
			new LimitOrder(price, Math.abs(amount)) as ILimitOrder
		}
	}

}
