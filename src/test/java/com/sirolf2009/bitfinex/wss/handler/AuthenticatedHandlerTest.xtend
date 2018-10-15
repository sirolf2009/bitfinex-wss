package com.sirolf2009.bitfinex.wss.handler

import com.google.common.eventbus.EventBus
import com.google.common.eventbus.Subscribe
import com.google.gson.Gson
import com.google.gson.JsonArray
import com.sirolf2009.bitfinex.wss.model.FundingType
import com.sirolf2009.bitfinex.wss.model.Position
import com.sirolf2009.bitfinex.wss.model.PositionStatus
import com.sirolf2009.bitfinex.wss.model.UserOrder
import com.sirolf2009.bitfinex.wss.model.UserOrderType
import com.sirolf2009.bitfinex.wss.model.UserTrade
import java.util.concurrent.atomic.AtomicReference
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.assertEquals
import static org.junit.Assert.assertFalse
import com.sirolf2009.bitfinex.wss.model.UserOrderStatus
import java.util.Optional

class AuthenticatedHandlerTest {

	static val eventBus = new EventBus()
	static val handler = new AuthenticatedHandler(eventBus)
	static val message = new AtomicReference<Object>()

	@Before
	def void setup() {
		eventBus.register(this)
	}

	@Test
	def void testPositionSnapshot() {
		handler.onData('''[0,"ps",[["tBTCUSD","ACTIVE",0.01,10495,0,0]]]'''.parseArray())
		(message.get() as Position) => [
			assertEquals(0, channelID)
			assertEquals("tBTCUSD", pair)
			assertEquals(PositionStatus.ACTIVE, status)
			assertEquals(0.01, amount, 0.0001)
			assertEquals(10495, basePrice, 0.0001)
			assertEquals(0, marginFunding, 0.0001)
			assertEquals(FundingType.DAILY, fundingType)
		]
	}

	@Test
	def void testPositionUpdate() {
		handler.onData('''[0,"pu",["tBTCUSD","ACTIVE",0.02,10491.5,0,0]]'''.parseArray())
		(message.get() as Position) => [
			assertEquals(0, channelID)
			assertEquals("tBTCUSD", pair)
			assertEquals(PositionStatus.ACTIVE, status)
			assertEquals(0.02, amount, 0.0001)
			assertEquals(10491.5, basePrice, 0.0001)
			assertEquals(0, marginFunding, 0.0001)
			assertEquals(FundingType.DAILY, fundingType)
		]
	}

	@Test
	def void testOrderSnapshot() {
		handler.onData('''[0,"os",[[7478630889,null,70244865068,"tBTCUSD",1516735844890,1516735844928,-0.01,-0.01,"LIMIT",null,null,null,0,"ACTIVE",null,null,11199,0,null,null,null,null,null,0,0,0]]]'''.parseArray)
		(message.get() as UserOrder) => [
			assertEquals(-1111303703, orderID)
			assertFalse(groupID.present)
			assertEquals(1525388332, clientID.get())
			assertEquals("tBTCUSD", pair)
			assertEquals(-0.01, amount, 0.0001)
			assertEquals(-0.01, originalAmount, 0.0001)
			assertEquals(UserOrderType.LIMIT, orderType)
			assertFalse(prevOrderType.present)
			assertEquals(0, flags)
			assertEquals(UserOrderStatus.ACTIVE, orderStatus)
			assertEquals(11199, price, 0.0001)
			assertEquals(0, priceAvg, 0.0001)
			assertFalse(priceTrailing.present)
			assertFalse(priceAuxLimit.present)
			assertFalse(isNotify())
			assertFalse(hidden)
			assertEquals(Optional.of(0), placedID)
		]
	}

	@Test
	def void testOrderCancellation() {
		handler.onData('''[0,"oc",[7478630799, null,70244678256,"tBTCUSD",1516735844708,1516738370469,0,0.01,"LIMIT",null,null,null,0,"EXECUTED @ 10901.0(0.01)",null,null,10901,10901,null,null,null,null,null,0,0,0]]'''.parseArray())
		(message.get() as UserOrder) => [
			assertEquals(-1111303793, orderID)
			assertFalse(groupID.present)
			assertEquals(1525201520, clientID.get())
			assertEquals("tBTCUSD", pair)
			assertEquals(0, amount, 0.0001)
			assertEquals(0.01, originalAmount, 0.0001)
			assertEquals(UserOrderType.LIMIT, orderType)
			assertFalse(prevOrderType.present)
			assertEquals(0, flags)
			assertEquals(UserOrderStatus.EXECUTED, orderStatus)
			assertEquals(10901, price, 0.0001)
			assertEquals(10901, priceAvg, 0.0001)
			assertFalse(priceTrailing.present)
			assertFalse(priceAuxLimit.present)
			assertFalse(isNotify())
			assertFalse(hidden)
			assertEquals(Optional.of(0), placedID)
		]
	}

	@Test
	def void testOrderNew() {
		handler.onData('''[0,"on",[7478221181,null,69211004383,"tBTCUSD",1516734811020,1516734811031,0.01,0.01,"LIMIT",null,null,null,0,"ACTIVE",null,null,11051,0,null,null,null,null,null,0,0,0]]'''.parseArray)
		(message.get() as UserOrder) => [
			assertEquals(-1111713411, orderID)
			assertFalse(groupID.present)
			assertEquals(491527647, clientID.get())
			assertEquals("tBTCUSD", pair)
			assertEquals(0.01, amount, 0.0001)
			assertEquals(0.01, originalAmount, 0.0001)
			assertEquals(UserOrderType.LIMIT, orderType)
			assertFalse(prevOrderType.present)
			assertEquals(0, flags)
			assertEquals(UserOrderStatus.ACTIVE, orderStatus)
			assertEquals(11051, price, 0.0001)
			assertEquals(0, priceAvg, 0.0001)
			assertFalse(priceTrailing.present)
			assertFalse(priceAuxLimit.present)
			assertFalse(isNotify())
			assertFalse(hidden)
			assertEquals(Optional.of(0), placedID)
		]
	}

	@Test
	def void testTradeUpdate() {
		handler.onData('''[0,"tu",[176958953,"tBTCUSD",1516735847789,7478630843,0.01,11151,"LIMIT",11151,1,-0.11151,"USD"]]'''.parseArray())
		(message.get() as UserTrade) => [
			assertEquals(0, channelID)
			assertEquals("176958953", tradeID)
			assertEquals("tBTCUSD", pair)
			assertEquals(-1111303749, orderID)
			assertEquals(0.01, amount, 0.0001)
			assertEquals(11151, price, 0.0001)
			assertEquals(UserOrderType.LIMIT, type)
			assertEquals(11151.0, orderPrice, 0.0001)
			assertEquals(-0.11151, fee, 0.0001)
			assertEquals("USD", feeCurrency)
		]
	}

	@Subscribe def void onPosition(Position position) {
		message.set(position)
	}

	@Subscribe def void onOrder(UserOrder order) {
		message.set(order)
	}

	@Subscribe def void onTrade(UserTrade trade) {
		message.set(trade)
	}

	def parseArray(CharSequence json) {
		return new Gson().fromJson(json.toString(), JsonArray)
	}

}
