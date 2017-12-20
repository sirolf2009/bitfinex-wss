package com.sirolf2009.bitfinex.wss.model

import java.util.Date
import java.util.Optional
import org.eclipse.xtend.lib.annotations.Data

@Data class UserOrder  {
	
	val long channelID
	val long orderID
	val String pair
	val float amount
	val float originalAmount
	val UserOrderType type
	val UserOrderStatus status
	val float price
	val float averagePrice
	val Date timestamp
	val boolean notify
	val boolean hidden
	val Optional<Integer> oco
	
}