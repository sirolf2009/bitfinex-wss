package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data
import com.sirolf2009.commonwealth.trading.orderbook.ILimitOrder

@Data class LimitOrder implements ILimitOrder {

	val long channelID
	val double price
	val int count
	val double amount
	
	override getPrice() {
		return price
	}
	
	override getAmount() {
		return amount
	}

}
