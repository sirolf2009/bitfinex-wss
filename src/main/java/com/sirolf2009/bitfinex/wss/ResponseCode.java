package com.sirolf2009.bitfinex.wss;

public enum ResponseCode {

	UNKNOWN_EVENT(10000, "Unkown event", ResponseLevel.ERROR), UNKNOWN_PAIR(10001, "Unkown pair", ResponseLevel.ERROR), RECONNECT(20051, "Stop/Restart Websocket Server (please try to reconnect)", ResponseLevel.INFO), PAUSE(20060, "Refreshing data from the Trading Engine. Please pause any activity and resume after receiving the info message 20061 (it should take 10 seconds at most).", ResponseLevel.INFO), RESUME(20061, "Done Refreshing data from the Trading Engine. You can resume normal activity. It is advised to unsubscribe/subscribe again all channels.", ResponseLevel.INFO), SUBSCRIPTION_FAILED(10300, "Subscription failed (generic)", ResponseLevel.ERROR), ALREADY_SUBSCRIBED(10301, "Already subscribed", ResponseLevel.ERROR), UNKNOWN_CHANNEL(10302, "Unknown channel", ResponseLevel.ERROR), UNSUBSCRIPTION_FAILED(10400, "Unsubscription failed (generic)", ResponseLevel.ERROR), NOT_SUBSCRIBED(10401, "Not subscribed", ResponseLevel.ERROR), UNKNOWN_BOOK_PREC(10011, "Unknown Book precision",
			ResponseLevel.ERROR), UNKNOWN_BOOK_LENGTH(10012, "Unknown Book length", ResponseLevel.ERROR);

	private final int code;
	private final String message;
	private final ResponseLevel level;

	private ResponseCode(int code, String message, ResponseLevel level) {
		this.code = code;
		this.message = message;
		this.level = level;
	}

	public int getCode() {
		return code;
	}

	public String getMessage() {
		return message;
	}

	public ResponseLevel getLevel() {
		return level;
	}

}
