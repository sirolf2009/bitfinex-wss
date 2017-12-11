package com.sirolf2009.bitfinex.wss.event

import com.google.common.eventbus.EventBus
import com.sirolf2009.bitfinex.wss.model.SubscribeResponse
import org.eclipse.xtend.lib.annotations.Data

@Data class OnSubscribed {
	
	val SubscribeResponse response
	val EventBus eventBus
	
}