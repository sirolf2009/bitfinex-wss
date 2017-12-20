package com.sirolf2009.bitfinex.wss.handler

import com.google.common.eventbus.EventBus
import com.google.common.eventbus.Subscribe
import com.google.gson.JsonArray
import com.sirolf2009.bitfinex.wss.model.Ticker
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

@FinalFieldsConstructor class TickerHandler {
	
	val EventBus eventBus
	
	@Subscribe def void onData(JsonArray array) {
		val channelID = array.get(0).asLong
		val bid = array.get(1).asFloat
		val bidSize = array.get(2).asFloat
		val ask = array.get(3).asFloat
		val askSize = array.get(4).asFloat
		val dailyChange = array.get(5).asFloat
		val dailychangePercentage = array.get(6).asFloat
		val lastPrice = array.get(7).asFloat
		val volume = array.get(8).asFloat
		val high = array.get(9).asFloat
		val low = array.get(10).asFloat
		eventBus.post(new Ticker(channelID, bid, bidSize, ask, askSize, dailyChange, dailychangePercentage, lastPrice, volume, high, low))
	}
	
}