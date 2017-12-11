package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data

@Data class SubscribeOrderbook {
	
	public static val PREC_MOST_PRECISE="P0"
	public static val PREC_PRECISE="P1"
	public static val PREC_IMPRECISE="P2"
	public static val PREC_MOST_IMPRECISE="P3"
	public static val FREQ_REALTIME="F0"
	public static val FREQ_2SECONDS="F1" 
	
	val String event = "subscribe"
	val String channel = "book"
	val String pair
	val String prec
	val String freq
	
}