package com.sirolf2009.bitfinex.wss.model

import java.util.Date
import org.eclipse.xtend.lib.annotations.Data

@Data class UserTrade {
	
	val long channelID
	val int tradeID
	val String pair
	val Date timestamp
	val int orderID
	val float amount
	val float price
	val UserOrderType type
	val float orderPrice
	val float fee
	val String feeCurrency
	
}