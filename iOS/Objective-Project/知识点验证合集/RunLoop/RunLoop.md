#  RunLoop



### 1. Run Loop 模式
### 2. Run Loop 输入源

##### 1. 基于端口的输入源

**`只要简单的创建端口对象，并使用 NSPort 的方法把该端口添加到 run loop。端口对象会自己处理和配置输入源`**

##### 2. 自定义输入源

**`为了创建自定义输入源，必须使用 Core Foundation 里面的 CFRunLoopSourceRef类型相关的函数来创建。`**

##### 3. Cocoa selector 源

执行 selector 请求会在目标线程上序列化，减缓许多在线程上允许多个方法容易引起的同步问题。不像基于端口的源，一个 selector执行完后会自动从 run loop 里面移除。

`当在其他线程上面执行 selector 时，目标线程须有一个活动的 run loop。`

##### 4. 定时源

定时源在预设的时间点同步方式传递消息。定时器是线程通知自己做某事的一种方法。


​				
​			
​		
​	

