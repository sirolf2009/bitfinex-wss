package com.sirolf2009.bitfinex.wss.model

import com.sirolf2009.util.GSonDTO
import org.eclipse.xtend.lib.annotations.Data

@Data @GSonDTO class Error {
	
	val String event
	val String msg
	val String code
	
}