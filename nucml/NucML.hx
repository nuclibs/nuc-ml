package nucml;

import nucml.Token;


class NucML {

	static public function parse(document:String):Dynamic {
		var scanner = new Scanner(document);
		var tokens = scanner.scanTokens();
		var parser = new Parser(tokens);
		return parser.parse();
	}

	static function error(line:Int, column:Int, message:String) {
		report(line, column, "", message);
	}

	static function parseError(token:Token, message:String) {
		if (token.type == TokenType.EOF) {
			report(token.line, token.column, "at end", message);
		} else {
			report(token.line, token.column, "at '" + token.value + "'", message);
		}
	}

	static function report(line:Int, column:Int, where:String, message:String) {
		Sys.println('[line $line, column $column] Error $where: $message');
	}
}