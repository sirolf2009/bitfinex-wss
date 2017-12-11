package com.sirolf2009.bitfinex.wss.event

import org.eclipse.xtend.lib.annotations.Data

@Data class OnDisconnected {
	
	val int code
	val String reason
	val boolean remote
	
}