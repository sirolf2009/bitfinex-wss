package com.sirolf2009.bitfinex.wss.event

import com.google.common.eventbus.EventBus
import com.sirolf2009.bitfinex.wss.model.AuthenticateSuccess
import org.eclipse.xtend.lib.annotations.Data

@Data class OnAuthenticated {
	
	val AuthenticateSuccess response
	val EventBus eventBus
	
}