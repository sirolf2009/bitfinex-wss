package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data
import com.sirolf2009.util.GSonDTO

@Data @GSonDTO class UnsubscribeResponse {
	
	val String event
	val String status
	val String chanId
	
}