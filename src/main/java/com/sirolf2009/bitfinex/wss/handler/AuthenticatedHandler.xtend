package com.sirolf2009.bitfinex.wss.handler

import com.google.common.eventbus.EventBus
import com.google.common.eventbus.Subscribe
import com.google.gson.JsonArray
import com.sirolf2009.bitfinex.wss.model.FundingType
import com.sirolf2009.bitfinex.wss.model.Position
import com.sirolf2009.bitfinex.wss.model.PositionStatus
import com.sirolf2009.bitfinex.wss.model.UserOrder
import com.sirolf2009.bitfinex.wss.model.UserOrderStatus
import com.sirolf2009.bitfinex.wss.model.UserOrderType
import com.sirolf2009.bitfinex.wss.model.UserTrade
import com.sirolf2009.bitfinex.wss.model.Wallet
import com.sirolf2009.bitfinex.wss.model.WalletType
import com.sirolf2009.util.TimeUtil
import java.util.Optional
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

@FinalFieldsConstructor class AuthenticatedHandler {
	
	val EventBus eventBus
	
	@Subscribe def void onData(JsonArray array) {
		val channel = array.get(0).asLong
		val type = array.get(1).asString
		if(type.equals("ps")) {
			val positions = array.get(2).asJsonArray
			positions.map[asJsonArray].forEach[
				val pair = get(0).asString
				val status = positionStatuses.get(get(1).asString)
				val amount = get(2).asFloat
				val basePrice = get(3).asFloat
				val marginFunding = get(4).asFloat
				val marginFundingType = if(get(5).asInt == 0) FundingType.DAILY else FundingType.TERM
				eventBus.post(new Position(channel, pair, status, amount, basePrice, marginFunding, marginFundingType))
			]
		} else if(type.equals("ws")) {
			val wallets = array.get(2).asJsonArray
			wallets.map[asJsonArray].forEach[
				val walletType = walletTypes.get(get(0).asString)
				val symbol = get(1).asString
				val amount = get(2).asFloat
				eventBus.post(new Wallet(walletType, symbol, amount))
			]
		} else if(type.equals("os")) {
			val orders = array.get(2).asJsonArray
			orders.map[asJsonArray].forEach[
				val orderID = get(0).asLong
				val pair = get(1).asString
				val amount = get(2).asFloat
				val originalAmount = get(3).asFloat
				val orderType = orderTypes.get(get(4).asString)
				val orderStatus = orderStatuses.get(get(5).asString)
				val price = get(6).asFloat
				val avgPrice = get(7).asFloat
				val timestamp = TimeUtil.parseISO(get(8).asString)
				val notify = get(9).asInt == 1
				val hidden = get(10).asInt == 1
				val oco = if(get(11).asInt == 0) Optional.empty else Optional.of(get(11).asInt)
				eventBus.post(new UserOrder(channel, orderID, pair, amount, originalAmount, orderType, orderStatus, price, avgPrice, timestamp, notify, hidden, oco))
			]
		} else if(type.equals("ts")) {
			val trades = array.get(2).asJsonArray
			trades.map[asJsonArray].forEach[
				val tradeID = get(0).asInt
				val pair = get(1).asString
				val timestamp = TimeUtil.parseISO(get(2).asString)
				val orderID = get(3).asInt
				val amount = get(4).asFloat
				val price = get(5).asFloat
				val orderType = orderTypes.get(get(6).asString)
				val orderPrice = get(7).asFloat
				val fee = get(8).asFloat
				val feeCurrency = get(9).asString
				eventBus.post(new UserTrade(channel, tradeID, pair, timestamp, orderID, amount, price, orderType, orderPrice, fee, feeCurrency))
			]
		}
	}
	
	static val positionStatuses = #{
		"ACTIVE" -> PositionStatus.ACTIVE,
		"CLOSED" -> PositionStatus.CLOSED
	}
	
	static val walletTypes = #{
		"exchange" -> WalletType.EXCHANGE,
		"trading" -> WalletType.TRADING,
		"deposit" -> WalletType.DEPOSIT
	}
	
	static val orderTypes = #{
		"LIMIT" -> UserOrderType.LIMIT,
		"MARKET" -> UserOrderType.MARKET,
		"STOP" -> UserOrderType.STOP,
		"TRAILING STOP" -> UserOrderType.TRAILING_STOP,
		"EXCHANGE MARKET" -> UserOrderType.EXCHANGE_MARKET,
		"EXCHANGE LIMIT" -> UserOrderType.EXCHANGE_LIMIT,
		"EXCHANGE STOP" -> UserOrderType.EXCHANGE_STOP,
		"EXCHANGE TRAILING STOP" -> UserOrderType.EXCHANGE_TRAILING_STOP,
		"FOK" -> UserOrderType.FOK,
		"EXCHANGE FOK" -> UserOrderType.EXCHANGE_FOK
	}
	
	static val orderStatuses = #{
		"ACTIVE" -> UserOrderStatus.ACTIVE,
		"EXECUTED" -> UserOrderStatus.EXECUTED,
		"PARTIALLY FILLED" -> UserOrderStatus.PARTIALLY_FILLED,
		"CANCELED" -> UserOrderStatus.CANCELLED
	}
	
}