package nucml;

class Token {

	public var type:TokenType;
	public var value:String;
	public var line:Int;
	public var column:Int;

	public function new(type:TokenType, value:String, line:Int, column:Int) {
		this.type = type;
		this.value = value;
		this.line = line;
		this.column = column;
	}

	public function toString() {
		var v = '';
		if(value != null) {
			v = '= $value';
		}
		return '$type $v';
	}

}

enum TokenType {
	LESS;
	MORE;
	LEFT_BRACKET;
	RIGHT_BRACKET;
	LEFT_BRACE;
	RIGHT_BRACE;
	COLON;
	COMMA;
	IDENTIFIER;
	STRING;
	NUMBER;
	TRUE;
	FALSE;
	NULL;
	EOF;
}