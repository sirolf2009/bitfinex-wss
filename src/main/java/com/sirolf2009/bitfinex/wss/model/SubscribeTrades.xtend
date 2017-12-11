package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data

@Data class SubscribeTrades {
	
	val String event = "subscribe"
	val String channel = "trades"
	val String pair
}