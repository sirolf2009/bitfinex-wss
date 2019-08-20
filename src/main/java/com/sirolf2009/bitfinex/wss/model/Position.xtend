package com.sirolf2009.bitfinex.wss.model

import com.sirolf2009.commonwealth.timeseries.Point
import com.sirolf2009.commonwealth.trading.IPosition
import com.sirolf2009.commonwealth.trading.PositionType
import org.eclipse.xtend.lib.annotations.Data

@Data class Position implements IPosition {
	
	val long channelID
	val String pair
	val PositionStatus status
	val float amount
	val float basePrice
	val float marginFunding
	val FundingType fundingType
	val Float pl
	
	override getEntry() {
		return new com.sirolf2009.commonwealth.trading.Trade(new Point(-1, basePrice), amount)
	}
	
	override getExit() {
		return new com.sirolf2009.commonwealth.trading.Trade(new Point(System.currentTimeMillis(), basePrice), amount)
	}
	
	override getEntryFee() {
		return 0
	}
	
	override getExitFee() {
		return 0
	}
	
	override getPositionType() {
		return if(amount > 0) PositionType.LONG else PositionType.SHORT
	}
	
	override getMaxDrawdown() {
	}
	
	override getMaxDrawup() {
	}
	
}