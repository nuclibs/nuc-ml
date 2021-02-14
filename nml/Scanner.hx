package nml;

import nml.Token;

@:access(nml.Nml)
class Scanner {

	var source:String;
	var tokens:Array<Token>;
	var start:Int;
	var current:Int;
	var line:Int;
	var column:Int;

	public function new(source:String) {
		this.source = source;
		tokens = [];
		start = 0;
		current = 0;
		line = 0;
		column = 0;
	}

	public function scanTokens() {
		while (!isAtEnd()) {
			start = current;
			scanToken();
		}
		addToken(TokenType.EOF);
		return tokens;
	}
	
	function scanToken() {
		var c = peek();
		advance();
		switch c {
			case ":".code: addToken(TokenType.COLON);
			case "<".code: addToken(TokenType.LESS);
			case ">".code: addToken(TokenType.MORE);
			case "[".code: addToken(TokenType.LEFT_BRACKET);
			case "]".code: addToken(TokenType.RIGHT_BRACKET);
			case "{".code: addToken(TokenType.LEFT_BRACE);
			case "}".code: addToken(TokenType.RIGHT_BRACE);
			case ",".code: addToken(TokenType.COMMA);
			case "#".code: while (peek() != "\n".code && !isAtEnd()) advance();
			case " ".code | "\r".code | "\t".code: column++;
			case "\n".code: 
				line++;
				column = 0;
			case "'".code: addString();
			case _:
				if(isDigit(c)) {
					addNumber();
				} else if(isAlpha(c)) {
					addIndetifier();
				} else {
					Nml.error(line, column, 'Unexpected character: ${String.fromCharCode(c)}');
				}
		}
	}
	
	function addString() {
		while(peek() != "'".code && !isAtEnd()) {
			if(peek() == "\n".code) line++;
			advance();
		}
		
		if(isAtEnd()) {
			Nml.error(line, column, "Unterminated string.");
			return;
		}
		
		advance();
		
		var value = source.substring(start + 1, current - 1);
		addToken(TokenType.STRING, value);
	}
	
	function addNumber() {
		while(isDigit(peek())) advance();
		
		if(peek() == '.'.code && isDigit(peekNext())) {
			advance();
			
			while(isDigit(peek())) advance();
		}
		
		addToken(TokenType.NUMBER, source.substring(start, current));
	}
	
	function addIndetifier() {
		while (isAlphaNumeric(peek())) advance();

		var text = source.substring(start, current);

		if (text == "true") {
			addToken(TokenType.TRUE);
		} else if (text == "false") {
			addToken(TokenType.FALSE);
		} else if (text == "null") {
			addToken(TokenType.NULL);
		} else {
			addToken(TokenType.IDENTIFIER, text);
		}
	}
	
	function advance() {
		current++;
		column++;
	}
	
	function isAtEnd():Bool {
		return current >= source.length;
	}
	
	function isDigit(code:Int):Bool {
		return (code >= '0'.code) && (code <= '9'.code);
	}
	
	function isAlpha(code:Int):Bool {
		return (code >= 'a'.code && code <= 'z'.code) || 
				(code >= 'A'.code && code <= 'Z'.code) || 
				code == '_'.code;
	}
	
	function isAlphaNumeric(code:Int):Bool {
		return isAlpha(code) || isDigit(code);
	}
	
	function addToken(type:TokenType, ?value:String) {
		tokens.push(new Token(type, value, line, column));
	}
	
	function peek():Int {
		if(isAtEnd()) return 0;
		return source.charCodeAt(current);
	}

	function peekNext() {
		if(current + 1 >= source.length) return 0;
		return source.charCodeAt(current + 1);
	}

}