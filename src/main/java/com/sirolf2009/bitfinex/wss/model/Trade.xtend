package com.sirolf2009.bitfinex.wss.model

import com.sirolf2009.commonwealth.timeseries.IPoint
import com.sirolf2009.commonwealth.trading.ITrade
import org.eclipse.xtend.lib.annotations.Data

@Data class Trade implements ITrade {
	
	val Long channelID
	val TradeSequence seq
	val IPoint point
	val Number amount
	
}