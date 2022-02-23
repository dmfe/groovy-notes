.nr LL 7i
.nr PO 0.7i
.nr HM 0.5i
.nr LM 0.5i
.
.so macro.ms
.
.
.
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

.NH
Array initializers

.LP
In Java, array initializers take either of these two forms:

.B1
.DS L
.CW
int[] array = {1, 2, 3};            // Java array initializer shorthand syntax
int[] array2 = new int[] {4, 5, 6}; // Java array initializer long syntax
.DE
.B2

In Groovy, the
.CW "{ ... }"
block is reserved for closures. That means that you cannot create array literalas using Java's array initializer shorthand syntax. You instead borrow Groovy's literal  list notation like this:

.B1
.DS L
.CW
int[] array = [1, 2, 3]
.DE
.B2

For Groovy 3+, you can optionally use the Java's array initializer long syntax:

.B1
.DS L
.CW
// Groovy 3.0+ supports the Java-style array initialization long syntax
def array2 = new int[] {1, 2, 3}
.DE
.B2

.NH
Package scope visibility

.LP
In Groovy, omitting a modifier on a field doesn't result a package-private field like in Java:

.B1
.DS L
.CW
class Person {
  String name
}
.DE
.B2

Instead, it is used to create a
.I property ,
that is to say a
.I "private filed" ,
an associated
.I getter
and an associated
.I setter .

It is possible to create a package-private field by annotation it with
.CW @PackageScope :

.B1
.DS L
.CW
class Person {
  @PackageScope String name
}
.DE
.B2

.NH
ARM blocks

.LP
Java 7 introduced ARM (Automatic Resource Management) blocks like this:

.B1
.DS L
.CW
Path file = Paths.get("/path/to/file");
Charset charset = Charset.forName("UTF-8");
try (BufferedReader reader = Files.newBufferedReader(file, charset)) {
  String line;
  while ((line = reader.readLine()) != null) {
    System.out.println(line);
  }
} catch (IOException e) {
  e.printStackTrace();
}
.DE
.B2

Such blocks are supported from Groovy 3+. However, Groovy provides various methods relying on closures, which have the same effect while being more idiomatic. For example:

.B1
.DS L
.CW
new File('/path/to/file').eachLine('UTF-8') {
  println it
}
.DE
.B2

or, if you want a version closer to Java:

.B1
.DS L
.CW
new File('/path/to/file').withReader('UTF-8') { reader ->
  reader.eachLine {
    println it
  }
}
.DE
.B2

.NH
Inner classes

.RS
.LP
The implementation of anonymous inner classes and nested classes follow Java closely, but there are some differences, e.g. local variables accessed from within such classes don't have to be final. Some implementation details, which is used for
.CW groovy.lang.Closure
are piggy-backed when generating inner class bytecode.
.RE

.NH 2
Static inner classes

.LP
Here's an example of static inner class:

.B1
.DS L
.CW
class A {
  static class B {}
}

new A.B()
.DE
.B2

.NH 2
Anonymous Inner Classes

.B1
.DS L
.CW
import java.util.concurent.CountDownLatch
import java.util.concurent.TimeUnit

CountDownLatch called = new CountDownLatch(1)

Timer timer = new Timer()
timer.schedule(new TimerTask() {
  void run() {
    called.countDown()
  }
}, 0)

assert called.await(10, TimeUnit.SECONDS)
.DE
.B2

.NH 2
Creating Instances of Non-Static Inner Classes

.LP
In Java you can do this:

.B1
.DS L
.CW
public class Y {
  public class X {}
  public X foo() {
    return new X();
  }

  public static X createX(Y y) {
    return y.new X();
  }
}
.DE
.B2

Before 3.0.0 Groovy doesn't support the
.CW "y.new X()"
syntax. Insted, you have to write
.CW "new X(y)" ,
like in the code below:

.B1
.DS L
.CW
public class Y {
  public class X {}
  public X foo() {
    return new X()
  }
  public static X createX(Y y) {
    return new X(y)
  }
}
.DE
.B2

.RS
.LP
Caution though, Groovy supports calling methonds with one parameter without givinig an argument. The parameter will then have the value null. Basically the same rules apply to calling a constructor. There is a danger that you will write new X() instead of new X(this) for example. Groovy 3.0.0 supports Java style syntax for creating instances of non-static inner classes.
.RE

.NH
Lambda expressions and the method reference operator.

.LP
Java 8+ supports lambda expressions and the method reference operator
.CW :: ): (

.B1
.DS L
.CW
Runnable run = () -> System.out.println("Run"); // Java
list.forEach(System.out::println);
.DE
.B2

Groovy 3 and above also support these within the Parrot parser. In earlier versions of Groovy you should use closures instead:

.B1
.DS L
.CW
Runnable run = { println 'run' }
list.each { println it } // or list.each(this.&println)
.DE
.B2
