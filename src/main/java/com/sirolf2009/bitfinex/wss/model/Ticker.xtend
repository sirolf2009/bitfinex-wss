package com.sirolf2009.bitfinex.wss.model

import com.sirolf2009.commonwealth.timeseries.ICandlestick
import java.util.Date
import org.eclipse.xtend.lib.annotations.Data

@Data class Ticker implements ICandlestick {
	
	val long channelID
	val float bid
	val float bidSize
	val float ask
	val float askSize
	val float dailyChange
	val float dailyChangePercentage
	val float lastPrice
	val float volume
	val float high
	val float low
	
	override getOpen() {
		return lastPrice - dailyChange
	}
	
	override getClose() {
		return lastPrice
	}
	
	override getHigh() {
		return high
	}
	
	override getLow() {
		return low
	}
	
	override getTimestamp() {
		return new Date()
	}
	
}