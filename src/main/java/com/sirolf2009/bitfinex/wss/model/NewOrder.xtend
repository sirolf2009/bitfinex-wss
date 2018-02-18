package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data

@Data class NewOrder {
	
	val long cid = System.currentTimeMillis()
	val UserOrderType type
	val String symbol
	val String amount
	val String price
	
}