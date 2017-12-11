package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data

@Data abstract class SubscribeResponse {
	
	val String event
	val String channel
	val String chanId
	
}