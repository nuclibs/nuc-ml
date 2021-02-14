package;

import nucml.NucML;


class Main {

	static public function main() {

		var txt = "
		<module>
		boolTrue: true
		boolFalse: false
		number: 112.35
		string: 'some text'
		array: [1, 123, ['testset', 'dsa']]
		map: {some: 'thing', asd: 123123}
		<module2>
		mapValues: {name: 'Andrei', age: 32}
		";

		var data = NucML.parse(txt);
		trace(data);
	}

}