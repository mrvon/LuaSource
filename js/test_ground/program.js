document.writeln("Hello, World!");
document.writeln("----------------------------------------------------");

// The Method Invocation Pattern 

// Create myObject. It has a value and an increment
// method. The increment method tabkes an optional
// parameter. If the argument is not a number, then 1
// is used as the default.

var myObject = {
    value: 0,
    increment: function(inc) {
        if (typeof inc === 'number') {
            this.value += inc
        } else {
            this.value += 1
        }
    }
};

myObject.increment();
document.writeln(myObject.value);

myObject.increment(2);
document.writeln(myObject.value);

document.writeln("----------------------------------------------------");

// The Function Invocation Pattern
var add = function(a, b) {
    return a + b;
};

// When a function is invoked with this pattern,
// *this* is bound to the global object.
document.writeln(add(3, 4));

// Augment myObject with a double method
myObject.double = function() {
    var that = this; // Workaround

    var helper = function() {
        that.value = add(that.value, that.value);
    };

    helper();
}

myObject.double();
document.writeln(myObject.value);

document.writeln("----------------------------------------------------");

// Make a function that adds a lot of stuff.

// Note that defining the variable sum inside of
// the function does not interfere with the sum
// defined outside of the function. The function
// only sees the inner one.
var sum = function() {
    var i, sum = 0;
    for (i = 0; i < arguments.length; i++) {
        sum += arguments[i];
    }
    return sum;
}
document.writeln(sum(4, 8, 15, 16, 23, 42));

document.writeln("----------------------------------------------------");

Function.prototype.method = function(name, func) {
    if (! this.prototype[name]) {
        this.prototype[name] = func;
        return this;
    }
};

Function.method("fuck", function() {
    return "FUCK you!"
});

document.writeln(add.fuck());

Number.method('integer', function() {
    if (this < 0) {
        return Math.ceil(this);
    } else {
        return Math.floor(this);
    }
});

document.writeln((-10 / 3).integer());

document.writeln("----------------------------------------------------");

var hanoi = function hanoi(disc, src, aux, dst) {
    if (disc > 0) {
        hanoi(disc - 1, src, dst, aux);
        document.writeln("Move disc " + disc + " from " + src + " to "  + dst);
        hanoi(disc - 1, aux, src, dst);
    }
}

hanoi(3, "Src", "Aux", "Dst");

document.writeln("----------------------------------------------------");

// Define a walk_the_DOM function that visits every
// node of the tree in HTML source order, starting
// from some given node. It invokes a funciton,
// passing it each node in turn. walk_the_DOM calls
// itself to process each of the child nodes.
var walk_the_DOM = function walk(node, func) {
    func(node);
    node = node.firstChild;
    while (node) {
        walk(node, func);
        node = node.nextSibling;
    }
};

// Define a getElementsByAttribute function. It
// takes an attribute name string and an optional
// matching value. It calls walk_the_DOM, passing it a
// function that looks for an attribute name in the
// node. The matching nodes are accumulated in a
// results array.
var getElementsByAttribute = function(att, value) {
    var results = [];

    walk_the_DOM(
        document.body, function(node) {
            var actual = false
            if (node.nodeType === 1) {
                actual = node.getAttribute(att);
            }

            if (typeof actual === 'string' && 
                (actual === value || typeof value !== 'string')) {
                    results.push(node);
            }
        }
    );

    return results;
};

// Make a factorial function with tail
// recursion. It is tail recursive because
// it returns the result of calling itself.
//
// Javascript does not currently optimize this form.
var factorial = function factorial(i, a) {
    a = a || 1;
    if (i < 2) {
        return a;
    }
    return factorial(i - 1, a * i);
};

document.writeln(factorial(4));

document.writeln("----------------------------------------------------");

var foo = function() {
    var a = 3, b = 5;

    var bar = function() {
        var b = 7, c = 11;

        // At this point, a is 3, b is 7 and c is 11
        document.writeln(a, "\t", b, "\t", c)
        
        a += b + c;

        // At this point, a is 21, b is 7 and c is 11
        document.writeln(a, "\t", b, "\t", c)
    };

    // At this point, a is 3, b is 5 and c is not defined
    document.writeln(a, "\t", b, "\t", "not defined")
    
    bar();

    // At this point, a is 21, b is 5
    document.writeln(a, "\t", b, "\t", "not defined")

    var d = 1024;

    // At this point, d is 1024

    {
        // Unfortunately, JavaScript does not have block scope
        // even though its block syntax suggests that it does.
        // This confusion can be a source of errors.

        var d = 1023;
        // Change the outer d, not declare a new d here.
        // That's awful.
    }

    document.writeln(d)
};

foo();

document.writeln("----------------------------------------------------");

var myObject = (function() {
    var value = 0;

    return {
        increment: function(inc) {
            value += typeof inc === 'number' ? inc : 1;
        },
        getValue: function() {
            return value;
        }
    };
}());

document.writeln(myObject.getValue());
myObject.increment();
document.writeln(myObject.getValue());

document.writeln("----------------------------------------------------");

// Create a maker function called quo. It makes an
// Object with a get_status method and a private
// status property.
var quo = function(status) {
    return {
        get_status: function() {
            return status;
        }
    };
};

// Make an instance of quo.
var myQuo = quo("amazed");

document.writeln(myQuo.get_status());

document.writeln("----------------------------------------------------");

// Define a function that sets DOM node's color
// to yellow and then fades it to white.

var fade = function(node) {
    var level = 1;
    var step = function() {
        var hex = level.toString(16)
        node.style.backgroundColor = '#FFFF' + hex + hex;
        if (level < 15) {
            level += 1;
            setTimeout(step, 200);
        }
    };
    setTimeout(step, 200);
};

fade(document.body);

document.writeln("----------------------------------------------------");

String.method('deentityify', function() {
    // The entity table. It maps entity names to
    // characters.
    
    var entity = {
        quot: '"',
        lt: '<',
        gt: '>'
    }

    // Return the deentityify method.

    return function() {
        // This is the deentityify method. It calls the string
        // replace method, looking for substrings that start
        // with '&' and end with ';'. If the characters in
        // between are in the entity table, then replace the
        // entity with the character from the table. It uses
        // a regular expression (Chapter 7).
        
        return this.replace(/&([^&;]+);/g,
        function(a, b) {
            var r = entity[b];
            return typeof r === 'string' ? r : a;
        });
    };
}());

document.writeln('&lt;&quot;&gt;'.deentityify()); // <">

var serial_maker = function() {
    // Produce an object that produces unique strings. A
    // unique string is made up of two pairs: a prefix
    // and a sequence number. The object comes with
    // methods for setting the prefix and sequence
    // number, and a gensym method that produces unique
    // strings.

    var prefix = '';
    var seq = 0;
    return {
        set_prefix: function(p) {
            prefix = String(p);
        },
        set_seq: function(s) {
            seq = s;
        },
        gensym: function() {
            var result = prefix + seq;
            seq += 1;
            return result;
        }
    };
};

var seqer = serial_maker();
seqer.set_prefix('Q');
seqer.set_seq(1000);
document.writeln(seqer.gensym());
document.writeln(seqer.gensym());
document.writeln(seqer.gensym());

document.writeln("----------------------------------------------------");

// Curry
// TODO a little difficult for me. I am not fimilar with *apply* function.
Function.method("curry", function() {
    var slice = Array.prototype.slice,
        args = slice.apply(arguments),
        that = this;
    return function() {
        return that.apply(null, args.concat(slice.apply(arguments)));
    };
});

var add1 = add.curry(1);
document.writeln(add1(6));

document.writeln("----------------------------------------------------");

var call_time = 0;

var fibonacci = function(n) {
    call_time++
    return n < 2 ? n : fibonacci(n - 1) + fibonacci(n - 2);
};

for (var i = 0; i <= 10; i += 1) {
    document.writeln('// ' + i + ': ' + fibonacci(i));
}

document.writeln("function fibonacci have been call " + call_time + " times.");

document.writeln("----------------------------------------------------");

// Memoization
var fibonacci = (function() {
    var memo = [0, 1];
    var fib = function(n) {
        var result = memo[n];
        if (typeof result !== 'number') {
            result = fib(n - 1) + fib(n - 2);
            memo[n] = result;
        }
        return result;
    };
    return fib;
}());

for (var i = 0; i <= 10; i += 1) {
    document.writeln('// ' + i + ': ' + fibonacci(i));
}

document.writeln("----------------------------------------------------");

var memoizer = function(memo, formula) {
    var recur = function(n) {
        var result = memo[n];
        if (typeof result !== 'number') {
            result = formula(recur, n);
            memo[n] = result;
        }
        return result;
    };
    return recur;
};

var fibonacci = memoizer([0, 1], function(recur, n) {
    return recur(n - 1) + recur(n - 2);
});

for (var i = 0; i <= 10; i += 1) {
    document.writeln('// ' + i + ': ' + fibonacci(i));
}

document.writeln("----------------------------------------------------");

var factorial = memoizer([1, 1], function(recur, n) {
    return n * recur(n - 1);
});

document.writeln(factorial(4));

document.writeln("----------------------------------------------------");

var empty = [];
var numbers = [
    'zero', 'one', 'two', 'three', 'four',
    'five', 'six', 'seven', 'eight', 'nine'
];

document.writeln(empty[1]);
document.writeln(numbers[1]);
document.writeln(numbers['1']);

document.writeln(empty.length);
document.writeln(numbers.length);

var numbers_object = {
    '0': 'zero',
    '1': 'one',
    '2': 'two',
    '3': 'three',
    '4': 'four',
    '5': 'five',
    '6': 'six',
    '7': 'seven',
    '8': 'eight',
    '9': 'nine',
};

document.writeln(numbers_object[1]);
document.writeln(numbers_object["1"]);

var misc = [
    'string', 98.6, true, false, null, undefined,
    ['nestd', 'array'], {object: true}, NaN,
    Infinity
];

document.writeln(misc.length);
document.writeln(misc[7].object);

document.writeln("----------------------------------------------------");

var myArray = [];
document.writeln(myArray.length);

myArray[1000000] = true;
document.writeln(myArray.length);

// myArray contains one property.

document.writeln(numbers.length);
document.writeln(numbers);
numbers.length = 3;
document.writeln(numbers);

// append a element to the end of the array
numbers[numbers.length] = 'shi';
document.writeln(numbers);

numbers.push('go');
document.writeln(numbers);

delete numbers[2];
document.writeln(numbers);

numbers.splice(2, 1)
document.writeln(numbers);

for (var i = 0; i < numbers.length; i++) {
    document.write(numbers[i], " ");
}
document.writeln();

document.writeln("----------------------------------------------------");

Array.method('reduce', function(f, value) {
    for (var i = 0; i < this.length; i++) {
        value = f(this[i], value)
    }
    return value;
});

// Create an array of numbers.

var data = [4, 8, 15, 16, 23, 42];

// Define two simple functions. One will add two
// numbers. The other will multiply two numbers.

var add = function(a, b) {
    return a + b;
};

var mult = function(a, b) {
    return a * b;
};

// Invoke the data's reduce method, passing in the
// add function.
var sum = data.reduce(add, 0);

document.writeln(sum);

// Invoke the reduce method again, this time passing
// in the multiply funciton.
var product = data.reduce(mult, 1);

document.writeln(product);

// Because an array is really an object, we can add
// methods directly on an individual array.

// Give the data array a total function.

data.total = function() {
    return this.reduce(add, 0);
};

total = data.total();

document.writeln(total);

document.writeln("----------------------------------------------------");

Array.dim = function(dimension, initial) {
    var a = [];

    for (var i = 0; i < dimension; i++) {
        a[i] = initial;
    }

    return a;
};

// Make an array containing 10 zeros.
var myArray = Array.dim(10, 0);

document.writeln(myArray);

// Javascript does not have arrays of more than one dimension,
// but like most C language, it can have arrays of arrays.

var matrix = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
];

document.writeln(matrix[2][1]);

document.writeln("----------------------------------------------------");

Array.matrix = function(m, n, initial) {
    var a, i, j;
    var mat = [];

    for (i = 0; i < m; i++) {
        a = [];
        for (j = 0; j < n; j++) {
            a[j] = initial;
        }
        mat[i] = a;
    }

    return mat;
};

// Make a 4 * 4 matrix filled with zeros.

var myMatrix = Array.matrix(4, 4, 0);

document.writeln(myMatrix[3][3]);

// Method to make an identity matrix.
Array.identity = function(n) {
    var i;
    var mat = Array.matrix(n, n, 0);
    for (i = 0; i < n; i++) {
        mat[i][i] = 1;
    }
    return mat;
}

myMatrix = Array.identity(4);

document.writeln(myMatrix[3][3]);

document.writeln("identity matrix 4*4:");

for (var i = 0; i < 4; i ++) {
    for (var j = 0; j < 4; j++) {
        document.write(myMatrix[i][j], "\t");
    }
    document.writeln();
}

document.writeln("----------------------------------------------------");

// --------------------------- Array method ---------------------------

// array.concat(item...)

var a = ['a', 'b', 'c']; 
var b = ['x', 'y', 'z'];
var c = a.concat(b, true);
document.writeln(c);

document.writeln("----------------------------------------------------");

// array.join(separator)

var a = ['a', 'b', 'c'];
a.push('d');
var c = a.join('');
document.writeln(c);

document.writeln("----------------------------------------------------");

// array.pop()

var a = ['a', 'b', 'c'];
document.writeln(a);
document.writeln(a.pop());
document.writeln(a);

document.writeln("----------------------------------------------------");

// array.push(item...)

var a = ['a', 'b', 'c']; 
var b = ['x', 'y', 'z'];
var a_len = a.push(b, true);
document.writeln(a); // a is ['a', 'b', 'c', ['x', 'y', 'z'], true]
document.writeln(a_len, a.length);

document.writeln("----------------------------------------------------");

// array.reverse()

var a = ['a', 'b', 'c'];
var b = a.reverse();

document.writeln(a)
document.writeln(b)

document.writeln("----------------------------------------------------");

// array.shift()

// The shift method removes the first element from an array
// and return it. If the array is empty, it returns undefined.
// shift is usually much slower than pop:
var a = ['a', 'b', 'c'];
var c = a.shift();

document.writeln(a);
document.writeln(c);

document.writeln("----------------------------------------------------");

// array.slice(start, end)

// The slice method makes a shallow copy of a portion of an array.
// The first element copied will be array[start]. It will stop before
// copying array[end]. The end parameter is optional, and the default
// is array.length.

// left-closed right-open interval
// array[start, end)

var a = ['a', 'b', 'c'];
var b = a.slice(0, 1);
var c = a.slice(1);
var d = a.slice(1, 2);

document.writeln(b);
document.writeln(c);
document.writeln(d);

document.writeln("----------------------------------------------------");

// array.sort(comparefn)

var n = [4, 8, 15, 16, 23, 42];

document.writeln(n);

// sort as string
n.sort();

document.writeln(n);

n.sort(function(a, b) {
    return a - b;
});

document.writeln(n);

document.writeln("----------------------------------------------------");

// Function by takes a member name string and returns
// a comparison function that can be used to sort an
// array of objects that contain the member.

var by = function(name) { 
    return function(o, p) {
        var a, b;

        if (o && p && typeof o === 'object' && typeof p === 'object') {
            a = o[name];
            b = p[name];

            if (a === b) {
                return 0;
            }

            if (typeof a === typeof b) {
                return a < b ? -1 : 1;
            }

            return typeof a < typeof b ? - 1 : 1;
        } else {
            throw {
                name: 'Error',
                message: 'Expected an object when sorting by ' + name
            };
        }
    }
};

var s = [
    {first: 'Joe', last: 'Besser'},
    {first: 'Moe', last: 'Howard'},
    {first: 'Joe', last: 'DeRita'},
    {first: 'Shemp', last: 'Howard'},
    {first: 'Larry', last: 'Fine'},
    {first: 'Curly', last: 'Howard'}
];

s.print = function() {
    document.writeln("[");
    for (var i = 0; i < this.length; i++) {
        var o = s[i];
        document.writeln(o.first, "\t", o.last);
    }
    document.writeln("]");
};

s.print();
s.sort(by("first"));
s.print();

// The sort method is not stable. so:
s.sort(by("first")).sort(by("last"));
s.print();
// is not guaranteed to produce the correct sequence.
// If you want to sort on multiple keys. you again need
// to do more work. We can modify function *by* to take
// a second parameter, another compare method that will
// be called to break ties when the major key produces a match:


// Function by takes a member name string and an
// optional minor comparison function and returns
// a comparison function that can be used to sort an
// array of objects that contain that member. The
// minor comparion function is used to break ties
// when the o[name] and p[name] are equal.

var by = function(name, minor) {
    return function(o, p) {
        var a, b;

        if (o && p && typeof o === "object" && typeof p === "object") {
            a = o[name];
            b = p[name];

            if (a === b) {
                return typeof minor === "function" ? minor(o, p) : 0;
            }

            if (typeof a === typeof b) {
                return a < b ? -1 : 1;
            }

            return typeof a < typeof b ? - 1 : 1;
        } else {
            throw {
                name: 'Error',
                message: 'Expected an object when sorting by ' + name
            };
        }
    };
};

// Here is the right sequence.
s.sort(by("first", by("last")));
s.print();

document.writeln("----------------------------------------------------");

// array.splice(start, deleteCount, item...)

// the splice method removes elements from an array, replacing them with
// new items. The start parameter is the number of a position within the
// array. The deleteCount parameter is the number of elements to delete
// starting from that position. If there are additional parameters, those
// items will be inserted at that position. It returns an array containing
// the deleted elements.

var a = ['a', 'b', 'c'];
var r = a.splice(1, 1, 'ache', 'bug');
document.writeln(a)
document.writeln(r)
// a is ['a', 'ache', 'bug', 'c']
// r is ['b']

document.writeln("----------------------------------------------------");

// array.unshift(item...)

// The unshift method is like the push method except that it shoves the items
// onto the front of this array instead of at the end. It returns the array's
// new length.

var a = ['a', 'b', 'c'];
var r = a.unshift('?', '@');
// a = ['?', '@', 'a', 'b', 'c']
// r = 5

document.writeln(a)
document.writeln(r)

document.writeln("----------------------------------------------------");

// --------------------------- Function method ---------------------------

// The apply method invokes a function, passing in the object that
// will be bound to this and an optional array of arguments. The
// apply method is used in the apply invocation pattern.

Function.method('bind', function(that) {
    // Return a function that will call this function as
    // though it is a method of that object.
    
    var method = this,
        slice = Array.prototype.slice,
        args = slice.apply(arguments, [1]);

    return function() {
        return method.apply(that,
            args.concat(slice.apply(arguments, [0]))
        );
    };
});

var x = function() {
    return this.value;
}.bind({value: 666});

document.writeln(x());

// This example is too difficult for me
// but never mind, I'll come back.

document.writeln("----------------------------------------------------");

// --------------------------- Number method ---------------------------

// --------------------------- Object method ---------------------------

// object.hasOwnProperty(name)

// The hasOwnProperty method returns true if the object contains a property
// having the name. The property chain is not examined. This method is useless
// if the name is hasOwnProperty:

var a = {member: true};
var b = Object.create(a);
var t = a.hasOwnProperty("member");
var u = b.hasOwnProperty("member");
var v = b.member;

document.writeln(t);
document.writeln(u);
document.writeln(v);
document.writeln(a.hasOwnProperty("hasOwnProperty")); // useless
