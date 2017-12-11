package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data
import com.sirolf2009.util.GSonDTO

@Data @GSonDTO class Unsubscribe {
	
	val String event = "unsubscribe"
	val String chanId
	
}