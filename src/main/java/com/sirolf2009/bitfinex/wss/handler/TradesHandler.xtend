package com.sirolf2009.bitfinex.wss.handler

import com.google.common.eventbus.EventBus
import com.google.common.eventbus.Subscribe
import com.google.gson.JsonArray
import com.sirolf2009.bitfinex.wss.model.Trade
import com.sirolf2009.bitfinex.wss.model.TradeSequence
import com.sirolf2009.commonwealth.timeseries.Point
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

@FinalFieldsConstructor class TradesHandler {

	val EventBus eventBus
	val EventBus eventBusTu

	@Subscribe def void onData(JsonArray array) {
		val channel = array.get(0).asLong
		if(array.get(1).jsonArray) {
			val data = array.get(1).getAsJsonArray()
			(0 ..< data.size()).map[data.get(it).asJsonArray].forEach [ trade |
				try {
					val timestamp = trade.get(1).asLong
					val price = trade.get(3).asDouble
					val amount = trade.get(2).asDouble
					eventBus.post(new Trade(channel, TradeSequence.TU, new Point(timestamp, price), amount))
				} catch(Exception e) {
					throw new RuntimeException("Failed to handle " + trade, e)
				}
			]
		} else {
			try {
				val it = array.get(2).asJsonArray
				val timestamp = get(1).asLong
				val amount = get(2).asDouble
				val price = get(3).asDouble
				if(array.get(1).asString.equals("te")) {
					eventBus.post(new Trade(channel, TradeSequence.TU, new Point(timestamp, price), amount))
				} else {
					eventBusTu.post(new Trade(channel, TradeSequence.TE, new Point(timestamp, price), amount))
				}
			} catch(Exception e) {
				throw new RuntimeException("Failed to handle " + array, e)
			}
		}
	}

}
