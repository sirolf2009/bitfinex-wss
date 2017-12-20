package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data
import com.sirolf2009.util.GSonDTO

@Data @GSonDTO class Info {
	
	val String event = "info"
	val short version
	
}