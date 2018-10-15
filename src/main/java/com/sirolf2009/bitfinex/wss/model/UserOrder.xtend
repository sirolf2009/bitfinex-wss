package com.sirolf2009.bitfinex.wss.model

import java.util.Date
import java.util.Optional
import org.eclipse.xtend.lib.annotations.Data

@Data class UserOrder {

	val int orderID
	val Optional<Integer> groupID
	val Optional<Integer> clientID
	val String pair
	val Date created
	val Date updated
	val float amount
	val float originalAmount
	val UserOrderType orderType
	val Optional<UserOrderType> prevOrderType
	val int flags
	val UserOrderStatus orderStatus
	val float price
	val float priceAvg
	val Optional<Float> priceTrailing
	val Optional<Float> priceAuxLimit
	val boolean notify
	val boolean hidden
	val Optional<Integer> placedID

}
