package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data

@Data class Ping {
	
	val String event = "ping"
	
}