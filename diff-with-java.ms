.so macro.ms
.TL
Groovy. Differences with Java.
.LP
Groovy tries to be as natural as possible for Java developers.
Groovy tries to follow the principle of least surprise, particularly for developers learning Groovy who've come from a Java background.

.LP
Here's a list of all major differences between Java and Groovy.

.NH
Default imports

.LP
All these packages and classes are imported by default, i.e. you do not have to use an explicit
.B "import"
statement to use them:

.RS
.BL
java.io.*
.BL
java.lang.*
.BL
java.math.BigDecimal
.BL
java.math.BigInteger
.BL
java.net.*
.BL
java.util.*
.BL
groovy.lang.*
.BL
groovy.util.*
.RE

.NH
Multi-methods

.LP
In Groovy, the methods which will be invoked are chosen at runtime.
This is called runtime dispatch or multi-methods.
It means that the method will be chosen based on the types of the arguments at runtime.
In Java, this is the opposite: methods are chosen at compile time, based on the declared types.

.LP
The following code, written as Java code, can be compiled in both Java and Groovy, but it will behave differently:

.B1
.DS L
.CW
int method(String arg) {
    return 1;
}
int method(Object arg) {
    return 2;
}
Object o = "Object";
int result = method(o);
.DE
.B2

In Java, you would have:

.B1
.DS L
.CW
assertEquals(2, result);
.DE
.B2

Whereas in Groovy:

.B1
.DS L
.CW
assertEquals(1, result);
.DE
.B2

That is because Java will use the static information type, which is that
.B o
is declared as an
.B Object
, whereas Groovy will choose at runtime, when the method is actually called.
Since it is called with a
.B String
, then the
.B String
version is called.
