package com.sirolf2009.bitfinex.wss.handler

import com.google.common.eventbus.EventBus
import com.google.common.eventbus.Subscribe
import com.google.gson.JsonArray
import com.sirolf2009.commonwealth.timeseries.Point
import com.sirolf2009.commonwealth.trading.Trade
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

@FinalFieldsConstructor class TradesHandler {

	val EventBus eventBus
	
	@Subscribe def void onData(JsonArray array) {
		if(array.get(1).jsonArray) {
			val data = array.get(1).getAsJsonArray()
			(0 ..< data.size()).map[data.get(it).asJsonArray].forEach [ trade |
				try {
					val timestamp = trade.get(1).asLong
					val price = trade.get(2).asDouble
					val amount = trade.get(3).asDouble
					eventBus.post(new Trade(new Point(timestamp, price), amount))
				} catch(Exception e) {
					throw new RuntimeException("Failed to handle " + trade, e)
				}
			]
		} else if(array.get(1).asString.equals("te")) {
			try {
				val timestamp = array.get(3).asLong
				val price = array.get(4).asDouble
				val amount = array.get(5).asDouble
				eventBus.post(new Trade(new Point(timestamp, price), amount))
			} catch(Exception e) {
				throw new RuntimeException("Failed to handle " + array, e)
			}
		}
	}

}
