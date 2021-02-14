package nml;

import nml.Token;

@:access(nml.Nml)
class Parser {

	var tokens:Array<Token>;
	var current:Int;
	var data:Dynamic;
	var group:Dynamic;
	var groupName:String;

	public function new(tokens:Array<Token>) {
		this.tokens = tokens;
		current = 0;
	}

	public function parse() {
		data = {};

		if (tokens.length > 0) {
			if (peek().type != TokenType.LESS) error(peek(), "Expect group <group_name> at file begining");
			while (!isAtEnd()) {
				if (check(TokenType.LESS)) {
					groupDeclaration();
				} else if (check(TokenType.IDENTIFIER)) {
					varDeclaration(group);
				} else {
					error(peek(), "Expect group or key declaration.");
				}	
			}
		}
		return data;
	}

	function groupDeclaration() { 
		consume(TokenType.LESS, "Expect < before group declaration.");

		var g = consume(TokenType.IDENTIFIER, "Expect group name.");
		if (Reflect.hasField(data, g.value)) error(g, "Duplicate group declaration.");
		groupName = g.value;
		group = {};
		Reflect.setField(data, groupName, group);

		consume(TokenType.MORE, "Expect > after group declaration.");
	}

	function varDeclaration(group:Dynamic) { 
		var id = consume(TokenType.IDENTIFIER, "Expect key name.");
		consume(TokenType.COLON, "Expect ':' after key name.");
		if (Reflect.hasField(group, id.value)) error(id, 'Duplicate key declaration in "${groupName}" group.');
		var v = parseValue();
		Reflect.setField(group, id.value, v);
	}

	function parseValue():Dynamic {
		var token = peek();
		advance();
		var type = token.type;

		if (type == TokenType.STRING) {
			return token.value;
		} else if (type == TokenType.NUMBER) {
			return Std.parseFloat(token.value);
		} else if (type == TokenType.TRUE) {
			return true;
		} else if (type == TokenType.FALSE) {
			return false;
		} else if (type == TokenType.NULL) {
			return null;
		} else if (type == TokenType.LEFT_BRACKET) {
			var list = [];

			while (peek().type != TokenType.RIGHT_BRACKET) {
				list.push(parseValue());
				if (check(TokenType.COMMA)) advance();
				if (isAtEnd()) error(token, "Expect ']' after array declaration");
			}

			advance();

			return list;
		} else if (type == TokenType.LEFT_BRACE) {
			var map = {};

			while (peek().type != TokenType.RIGHT_BRACE) {
				varDeclaration(map);
				if (check(TokenType.COMMA)) advance();
				if (isAtEnd()) error(token, "Expect '}' after map declaration");
			}

			advance();

			return map;
		}

		error(token, "Expect variable after :");
		return null;
	}

	function consume(type:TokenType, message:String):Token { 
		if (check(type)) return advance();
		error(peek(), message);
		return null;
	}

	function check(type:TokenType) { 
		if (isAtEnd()) return false;
		return peek().type == type;
	}

	function advance() { 
		if (!isAtEnd()) current++;
		return previous();
	}

	function isAtEnd():Bool { 
		return peek().type == TokenType.EOF;
	}

	function peek():Token { 
		return tokens[current];
	}

	function previous():Token { 
		return tokens[current - 1];
	}

	function error(token:Token, message:String) { 
		Nml.parseError(token, message);
		Sys.exit(1);
	}
}