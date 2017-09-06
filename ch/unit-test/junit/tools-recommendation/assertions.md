## 断言

断言需要清楚准确地表述如何对测试结果进行验证，同时应该尽量保持简洁，让开发者专注于设计和编写`actual`与`expected`。书写断言的工具类已经成为测试框架中重要的一部分。一些 JVM 语言的测试框架的断言已经是非常接近自然语言的 DSL 了。

Scala 的测试框架 ScalaTest：
```scala
import collection.mutable.Stack
import org.scalatest._

class ExampleSpec extends FlatSpec with Matchers {

  "A Stack" should "pop values in last-in-first-out order" in {
    val stack = new Stack[Int]
    stack.push(1)
    stack.push(2)
    stack.pop() should be (2)
    stack.pop() should be (1)
  }

  it should "throw NoSuchElementException if an empty stack is popped" in {
    val emptyStack = new Stack[Int]
    a [NoSuchElementException] should be thrownBy {
      emptyStack.pop()
    } 
  }
}
```

Groovy 的测试框架 Spock
```groovy
class HelloSpockSpec extends spock.lang.Specification {
  def "length of Spock's and his friends' names"() {
    expect:
    name.size() == length

    where:
    name     | length
    "Spock"  | 5
    "Kirk"   | 4
    "Scotty" | 6
  }
} 
```

Kotlin 的测试框架 Spek + Kluent
```kotlin
import org.amshove.kluent.shouldBe
import org.amshove.kluent.tests.helpclasses.Person
import org.jetbrains.spek.api.Spek
import kotlin.test.assertFails

class ShouldBeTests : Spek({
    given("the shouldBe method") {
        on("checking objects with the same reference") {
            val firstObject = Person("Jon", "Doe")
            val secondObject = firstObject
            it("should pass") {
                firstObject shouldBe secondObject
            }
        }
        on("checking different objects") {
            val firstObject = Person("Foo", "Bar")
            val secondObject = Person("Foo", "Bar")
            it("should fail") {
                assertFails({firstObject shouldBe secondObject})
            }
        }
    }
})
```

而且完全可以使用这些语言的测试框架来测试一个纯 Java 语言的项目。

反观 Java 的测试框架 JUnit，只提供了有限的几个`assert`方法；好在有第三方的断言库可供选择，其中最主流的是`Hamcrest`和`AssertJ`，下面是二者的比较。

条目 | Hamcrest | AssertJ | 对比结论
---------|----------|---------|---------
 Github | https://github.com/hamcrest/JavaHamcrest | https://github.com/joel-costigliola/assertj-core | 相当
 社区活跃度 | [活跃(最近一年 900+ 提交)](https://www.openhub.net/p/assertj) | [一般(最近一年 200+ 提交)](https://www.openhub.net/p/hamcrest) | AssertJ 更好
 依赖配置 | JUnit 4 自带 | Java 7 和 Java 8 依赖不同 | Hamcrest 更好
 可读性 | 需使用`static import`导入 Matcher 来隐藏类名，一个断言一行 | Fluent 风格，一行语句可以连续多个断言 | AssertJ 更好
 IDE 友好程度 | 需要记忆各种 Matcher 的名字 | Fluent 风格直接可以代码补全 | AssertJ 更好
 浮点数支持 | `closeTo()` | 除了`isCloseTo`，还有`isBetween()`| AssertJ 更好
 集合支持 | 支持基本的`hasSize`、`hasItem` | 除了基本断言之外，还有`filter`等过滤方法，支持 lambda 语法（3.+版本）| AssertJ 更强大 
 异常支持 | 需要`try {...} catch (Exception e) {...}`并在`catch`子句中断言，没有专门的断言 | `assertThatThrownBy`接受一个 lambda 代替`try...catch...`，还额外提供了`hasCause()`、`hasMessage()`等额外断言方法 | AssertJ 更好
 错误信息 |  |  | 相当 
 自定义断言 | 实现`BaseMatcher` | 提供生成器自动生成 POJO 对象的自定义断言 | AssertJ 更好 
 与其他库配合 | `Mockito.argThat()`直接接受如`eq()`之类的 Matcher | 支持通过`AssertionMatcher`转换成`argThat`支持的Matcher | Hamcrest 更好
 特殊功能 | 有其他语言语言版本（学习曲线平缓） | "Soft" 断言、Predicate 断言、JUnit 和 TestNG 断言的自动迁移 | AssertJ 更好

可以看到，作为新兴的断言库，AssertJ 简化了不方便和低效的写法，而且还在不断的增加更加丰富的断言，如果现在选择纯 Java 语言的断言库，AssertJ应该是首选。使用起来非常简单，增加 AssertJ 依赖，使用`assertThat(objectUnderTest)`方法把要验证的“actual”对象传给它，剩下的就交给 IDE 了。

Maven 依赖：
```xml
<dependency>
  <groupId>org.assertj</groupId>
  <artifactId>assertj-core</artifactId>
  <!-- use 2.8.0 for Java 7 projects -->
  <version>3.8.0</version>
  <scope>test</scope>
</dependency>
```

代码示例：
```java
// 导入入口静态方法 assertThat 以及其它
import static org.assertj.core.api.Assertions.*;
...
assertThat(objectUnderTest). // 这里就有 IDE 的代码补全提示了
```

> Eclipse 可以配置`Content Assist -> Favorites`增加`org.assertj.core.api.Assertions`方便使用自动的静态导入。
