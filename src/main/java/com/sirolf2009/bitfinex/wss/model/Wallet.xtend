package com.sirolf2009.bitfinex.wss.model

import org.eclipse.xtend.lib.annotations.Data

@Data class Wallet {
	
	val WalletType type
	val String symbol
	val float amount
	
}