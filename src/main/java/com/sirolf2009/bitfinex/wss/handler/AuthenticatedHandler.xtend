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
import java.util.Date
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import com.google.gson.JsonElement
import java.util.Optional

@FinalFieldsConstructor class AuthenticatedHandler {

	val EventBus eventBus

	@Subscribe def void onData(JsonArray array) {
		val channel = array.get(0).asLong
		val type = array.get(1).asString
		if(type.equals("ps")) {
			array.snapshots.map[parsePosition(channel)].forEach [
				eventBus.post(it)
			]
		} else if(type.equals("pu")) {
			val it = array.get(2).asJsonArray
			eventBus.post(parsePosition(channel))
		} else if(type.equals("pc")) {
			val it = array.get(2).asJsonArray
			eventBus.post(parsePosition(channel))
		} else if(type.equals("ws")) {
			val wallets = array.get(2).asJsonArray
			wallets.map[asJsonArray].forEach [
				val walletType = walletTypes.get(get(0).asString)
				val symbol = get(1).asString
				val amount = get(2).asFloat
				eventBus.post(new Wallet(walletType, symbol, amount))
			]
		} else if(type.equals("os")) {
			array.snapshots.map[parseOrder(channel)].forEach [
				eventBus.post(it)
			]
		} else if(type.equals("on") || type.equals("ou") || type.equals("oc")) {
			val it = array.get(2).asJsonArray
			eventBus.post(parseOrder(channel))
		} else if(type.equals("ts")) {
			array.snapshots.map[parseTrade(channel)].forEach [
				eventBus.post(it)
			]
		} else if(type.equals("tu")) {
			val it = array.get(2).asJsonArray
			eventBus.post(parseTrade(channel))
		} else if(type.equals("te")) {
//			val it = array.get(2).asJsonArray
//			eventBus.post(parseTradeExecution(channel))
		}
	}

	def parsePosition(JsonArray it, long channel) {
		/*
		 * [0,"pu",["tBTCUSD","ACTIVE",0.006,8251,0,null,null,null,null,null]]
		 * [0,"pu",[
		 * 	0 POS_PAIR: "tBTCUSD"
		 *  1 POS_STATUS: "ACTIVE"
		 *  2 POS_AMOUNT: 0.006
		 *  3 POS_BASE_PRICE: 8251
		 *  4 POS_MARGIN_FUNDING: 0
		 *  5 POS_MARGIN_FUNDING_TYPE null
		 *  6 PL null
		 *  7 PL_PERC null
		 *  8 PRICE_LIQ null
		 *  9 LEVERAGE null
		 * ]]
		 */
		val pair = get(0).asString
		val status = positionStatuses.get(get(1).asString)
		val amount = get(2).asFloat
		val basePrice = get(3).asFloat
		val marginFunding = get(4).asFloat
		val marginFundingType = if(get(5).isJsonNull() || get(5).asInt == 0) FundingType.DAILY else FundingType.TERM
		return new Position(channel, pair, status, amount, basePrice, marginFunding, marginFundingType)
	}

	def parseOrder(JsonArray it, long channel) {
		val orderID = get(0).asInt
		val groupID = get(1).asOptInt
		val clientID = get(2).asOptInt
		val pair = get(3).asString
		val created = new Date(get(4).asLong)
		val updated = new Date(get(5).asLong)
		val amount = get(6).asFloat
		val originalAmount = get(7).asFloat
		val orderType = orderTypes.get(get(8).asString)
		val prevOrderType = get(9).asOptString.map[orderTypes.get(it)]
		//10 reserved
		//11 reserved
		val flags = get(12).asInt
		val orderStatus = orderStatuses.get(get(13).asString.split(" ").get(0))
		//14 reserved
		//15 reserved
		val price = get(16).asFloat
		val priceAvg = get(17).asFloat
		val priceTrailing = get(18).asOptFloat
		val priceAuxLimit = get(19).asOptFloat
		//20 reserved
		//21 reserved
		//22 reserved
		val notify = get(23).asInt == 1
		val hidden = get(24).asInt == 1
		val placedID = get(25).asInt
		return new UserOrder(orderID, groupID, clientID, pair, created, updated, amount, originalAmount, orderType, prevOrderType, flags, orderStatus, price, priceAvg, priceTrailing, priceAuxLimit, notify, hidden, placedID)
	}
	
	def parseTrade(JsonArray it, long channel) {
		val tradeID = get(0).asString
		val pair = get(1).asString
		val timestamp = new Date(get(2).asLong)
		val orderID = get(3).asInt
		val amount = get(4).asFloat
		val price = get(5).asFloat
		val orderType = orderTypes.get(get(6).asString)
		val orderPrice = get(7).asFloat
		val fee = get(9).asFloat
		val feeCurrency = get(10).asString
		new UserTrade(channel, tradeID, pair, timestamp, orderID, amount, price, orderType, orderPrice, fee, feeCurrency)
	}
	
	def parseTradeExecution(JsonArray it, long channel) {
		val tradeID = get(0).asString
		val pair = get(1).asString
		val timestamp = new Date(get(2).asLong)
		val orderID = get(3).asInt
		val amount = get(4).asFloat
		val price = get(5).asFloat
		val orderType = orderTypes.get(get(6).asString)
		val orderPrice = get(7).asFloat
		val fee = 0
		val feeCurrency = "USD"
		new UserTrade(channel, tradeID, pair, timestamp, orderID, amount, price, orderType, orderPrice, fee, feeCurrency)
	}

	def getSnapshots(JsonArray array) {
		array.get(2).asJsonArray.map[asJsonArray]
	}
	
	def getAsOptInt(JsonElement it) {
		if(jsonNull) {
			return Optional.empty()
		} else {
			return Optional.of(asInt)
		}
	}
	
	def getAsOptString(JsonElement it) {
		if(jsonNull) {
			return Optional.empty()
		} else {
			return Optional.of(asString)
		}
	}
	
	def getAsOptFloat(JsonElement it) {
		if(jsonNull) {
			return Optional.empty()
		} else {
			return Optional.of(asFloat)
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
