### Nuc Minimal Language  

Simple config language used for [Nuc](https://github.com/nuclibs/nuc) framework projects

##### Example
``` text
<moduleName>
string: 'myAwesomeProject'
number: 1
bool: true
nothing: null
array: [1, 1, 2, 3, 5, ['hey', 'there'], 8, 12]
map: {
	foo: true, 
	bar: [5, 1.618, 'awesome'], 
	also: 'someString'
}

<anotherModule>
same: true

```