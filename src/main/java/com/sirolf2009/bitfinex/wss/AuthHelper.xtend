package com.sirolf2009.bitfinex.wss

import javax.crypto.spec.SecretKeySpec
import javax.crypto.Mac
import java.util.List
import com.sirolf2009.bitfinex.wss.model.Authenticate

class AuthHelper {
	
	def static getAuth(String apiKey, String apiSecret) {
		val nonce = System.currentTimeMillis()*1000
		val payload = "AUTH"+nonce
		val sig = hmacSHA384(payload, apiSecret)
		return new Authenticate(apiKey, payload, nonce, sig)
	}

	def static hmacSHA384(String payload, String apiSecret) {
		val mac = Mac.getInstance("HmacSHA384")
		mac.init(new SecretKeySpec(apiSecret.bytes, "HmacSHA384"))
		return mac.doFinal(payload.bytes).bytesToHex
	}

	def static String bytesToHex(List<Byte> hash) {
		val hexString = new StringBuffer()
		(0 ..< hash.size()).forEach [
			val hex = Integer.toHexString(0xff.bitwiseAnd(hash.get(it)))
			if(hex.length() == 1) {
				hexString.append("0")
			}
			hexString.append(hex)
		]
		return hexString.toString()
	}

}
