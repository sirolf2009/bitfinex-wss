package com.sirolf2009.bitfinex.wss

import com.google.common.eventbus.EventBus
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.sirolf2009.bitfinex.wss.event.OnAuthenticated
import com.sirolf2009.bitfinex.wss.event.OnDisconnected
import com.sirolf2009.bitfinex.wss.event.OnSubscribed
import com.sirolf2009.bitfinex.wss.handler.AuthenticatedHandler
import com.sirolf2009.bitfinex.wss.handler.OrderbookHandler
import com.sirolf2009.bitfinex.wss.handler.TickerHandler
import com.sirolf2009.bitfinex.wss.handler.TradesHandler
import com.sirolf2009.bitfinex.wss.model.AuthenticateFailure
import com.sirolf2009.bitfinex.wss.model.AuthenticateSuccess
import com.sirolf2009.bitfinex.wss.model.Info
import com.sirolf2009.bitfinex.wss.model.SubscribeOrderbookResponse
import com.sirolf2009.bitfinex.wss.model.SubscribeOrderbookResponseJsonDeserializer
import com.sirolf2009.bitfinex.wss.model.SubscribeTickerResponse
import com.sirolf2009.bitfinex.wss.model.SubscribeTickerResponseJsonDeserializer
import com.sirolf2009.bitfinex.wss.model.SubscribeTrades
import com.sirolf2009.bitfinex.wss.model.SubscribeTradesResponse
import java.net.URI
import java.util.HashMap
import java.util.Map
import org.java_websocket.client.WebSocketClient
import org.java_websocket.handshake.ServerHandshake

class BitfinexWebsocketClient extends WebSocketClient {
	
	val Gson gson
	val Map<Long, EventBus> channels
	val EventBus eventBus 
	
	new() {
		super(createURI())
		gson = new GsonBuilder().registerTypeAdapter(SubscribeOrderbookResponse, new SubscribeOrderbookResponseJsonDeserializer()).registerTypeAdapter(SubscribeTickerResponse, new SubscribeTickerResponseJsonDeserializer()).create()
		channels = new HashMap()
		eventBus = new EventBus()
	}
	
	def send(Object object) {
		send(gson.toJson(object))
	}
	
	def getEventBus() {
		return eventBus
	}
	
	override onClose(int code, String reason, boolean remote) {
		eventBus.post(new OnDisconnected(code, reason, remote))
	}
	
	override onError(Exception ex) {
		eventBus.post(ex)
	}
	
	override onMessage(String message) {
		try {
			if(message.startsWith("{")) {
				val object = gson.fromJson(message, JsonObject)
				if(object.has("event")) {
					val event = object.get("event").getAsString()
					if(event.equals("info")) {
						eventBus.post(gson.fromJson(message, Info))
					} else if(event.equals("subscribed")) {
						if(object.get("channel").getAsString().equals("book")) {
							val response = gson.fromJson(message, SubscribeOrderbookResponse)
							val channelEventBus = new EventBus()
							channelEventBus.register(new OrderbookHandler(channelEventBus))
							channels.put(response.chanId, channelEventBus)
							channelEventBus.post(response)
							eventBus.post(new OnSubscribed(response, channelEventBus))
						} else if(object.get("channel").getAsString().equals("trades")) {
							val response = gson.fromJson(message, SubscribeTradesResponse)
							val channelEventBus = new EventBus()
							channelEventBus.register(new TradesHandler(channelEventBus, new EventBus()))
							channels.put(response.chanId, channelEventBus)
							channelEventBus.post(response)
							eventBus.post(new OnSubscribed(response, channelEventBus))
						} else if(object.get("channel").getAsString().equals("ticker")) {
							val response = gson.fromJson(message, SubscribeTickerResponse)
							val channelEventBus = new EventBus()
							channelEventBus.register(new TickerHandler(channelEventBus))
							channels.put(response.chanId, channelEventBus)
							channelEventBus.post(response)
							eventBus.post(new OnSubscribed(response, channelEventBus))
						}
					} else if(event.equals("auth")) {
						if(object.get("status").getAsString().equals("OK")) {
							val response = gson.fromJson(message, AuthenticateSuccess)
							val channelEventBus = new EventBus()
							channelEventBus.register(new AuthenticatedHandler(channelEventBus))
							channels.put(response.chanId, channelEventBus)
							channelEventBus.post(response)
							eventBus.post(new OnAuthenticated(response, channelEventBus))
						} else {
							eventBus.post(gson.fromJson(message, AuthenticateFailure))
						}
					}
				}
			} else if(message.startsWith("[")) {
				val array = gson.fromJson(message, JsonArray)
				val channelID = array.get(0).asLong
				if(array.size() == 2 && array.get(1).toString.equals("\"hb\"")) {
				} else if(channels.containsKey(channelID)) {
					channels.get(channelID).post(array)
				}
			}
		} catch(Exception e) {
			e.printStackTrace()
		}
	}
	
	override onOpen(ServerHandshake handshakedata) {
		eventBus.post(handshakedata)
	}
	
	def static createURI() {
		return new URI("wss://api.bitfinex.com/ws/2")
	}
	
	def static void main(String[] args) {
		new BitfinexWebsocketClient() => [
			connectBlocking()
//			send(new SubscribeOrderbook("BTCUSD", SubscribeOrderbook.PREC_PRECISE, SubscribeOrderbook.FREQ_REALTIME))
			send(new SubscribeTrades("BTCUSD"))
		]
	}
	
}
