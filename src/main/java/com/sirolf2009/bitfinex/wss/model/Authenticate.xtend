package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data

@Data class Authenticate {

	val String event = "auth"
	val String status = "OK"
	val long chanId = 0
	val String apiKey
	val String authPayload
	val long authNonce
	val String authSig

}