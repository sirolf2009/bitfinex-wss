package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data

@Data class SubscribeTicker {
	
	val String event = "subscribe"
	val String channel = "ticker"
	val String pair
	
}