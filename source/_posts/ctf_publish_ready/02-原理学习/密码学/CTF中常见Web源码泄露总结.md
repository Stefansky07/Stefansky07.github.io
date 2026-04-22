---
title: "CTF中常见Web源码泄露总结"
date: 2025-09-12 21:44:00
categories:
  - CTF学习笔记
  - 脚本
tags:
  - Script
  - Web
  - 源码泄露
  - 工具实操
disableNunjucks: true
---
# CTF中常见Web源码泄露总结 

‍

[00x1 .ng 源码泄露](#yi)

 [00x2  git 源码泄露](#er)

 [00x3 .DS_Store 文件泄漏](#san)

 [00x4 网站备份压缩文件](#si)

 [00x5 SVN 导致文件泄露](#wu)

 [00x6 WEB-INF/web.xml 泄露](#liu)

 [00x7 CVS 泄漏](#qi)

 [工具推荐](#ba)

 [参考](#jiu)

### 0x01 .hg 源码泄漏

**漏洞成因：**

　　hg init 的时候会生成. hg

```java
<span>e</span><span>.</span><span>g</span><span>.</span><span>http</span><span>:</span><span>//www.am0s.com/.hg/</span>

```

**漏洞利用：**

工具：[dvcs-ripper](https://github.com/kost/dvcs-ripper)

```
<span>rip</span><span>-</span><span>hg</span><span>.</span><span>pl </span><span>-</span><span>v </span><span>-</span><span>u http</span><span>:</span><span>//www.am0s.com/.hg/</span>

```

### 0x02 .git 源码泄漏

**漏洞成因：**

　　在运行 git init 初始化代码库的时候，会在当前目录下面产生一个. git 的隐藏文件，用来记录代码的变更记录等等。在发布代码的时候，把. git 这个目录没有删除，直接发布了。使用这个文件，可以用来恢复源代码.

PHP

```
<span>e</span><span>.</span><span>g</span><span>.</span><span> http</span><span>:</span><span>//www.am0s.com/.git/config</span>

```

**漏洞利用：**

工具：

[GitHack](https://github.com/lijiejie/GitHack)

```
<span>GitHack</span><span>.</span><span>py http</span><span>:</span><span>//www.am0s.com/.git/</span>

```

[dvcs-ripper](https://github.com/kost/dvcs-ripper)

```
<span>rip</span><span>-</span><span>git</span><span>.</span><span>pl </span><span>-</span><span>v </span><span>-</span><span>u http</span><span>:</span><span>//www.am0s.com/.git/</span>

```

### 0x03 .DS_Store 文件泄漏

**漏洞成因:**

　　在发布代码时未删除文件夹中隐藏的. DS_store，被发现后，获取了敏感的文件名等信息。

**漏洞利用:**

PHP

```
<span>http</span><span>:</span><span>//www.am0s.com/.ds_store</span>

```

注意路径检查

工具：

[dsstoreexp](https://github.com/lijiejie/ds_store_exp)

PHP

```
<span>python ds_store_exp</span><span>.</span><span>p

```

---

### 0x04 网站备份压缩文件

在网站的使用过程中，往往需要对网站中的文件进行修改、升级。此时就需要对网站整站或者其中某一页面进行备份。当备份文件或者修改过程中的缓存文件因为各种原因而被留在网站 web 目录下，而该目录又没有设置访问权限时，便有可能导致备份文件或者编辑器的缓存文件被下载，导致敏感信息泄露，给服务器的安全埋下隐患。

**漏洞成因及危害:**

该漏洞的成因主要有以下两种：

1. 服务器管理员错误地将网站或者网页的备份文件放置到服务器 web 目录下。
2. 编辑器在使用过程中自动保存的备份文件或者临时文件因为各种原因没有被删除而保存在 web 目录下。

**漏洞检测:**

该漏洞往往会导致服务器整站源代码或者部分页面的源代码被下载，利用。源代码中所包含的各类敏感信息，如服务器数据库连接信息，服务器配置信息等会因此而泄露，造成巨大的损失。被泄露的源代码还可能会被用于代码审计，进一步利用而对整个系统的安全埋下隐患。

![](http://assets.cnblogs.com/images/copycode.gif)[javascript:void(0);](javascript:void(0); "复制代码")

```
<span>.</span><span>rar
</span><span>.</span><span>zip
</span><span>.</span><span>7z</span>
<span>.</span><span>tar</span><span>.</span><span>gz
</span><span>.</span><span>bak
</span><span>.</span><span>swp
</span><span>.</span><span>txt
</span><span>.</span><span>html</span>

```

![](http://assets.cnblogs.com/images/copycode.gif)[javascript:void(0);](javascript:void(0); "复制代码")

### 0x05 SVN 导致文件泄露

Subversion，简称 SVN，是一个开放源代码的版本控制系统，相对于的 RCS、CVS，采用了分支管理系统，它的设计目标就是取代 CVS。互联网上越来越多的控制服务从 CVS 转移到 Subversion。

Subversion 使用服务端—客户端的结构，当然服务端与客户端可以都运行在同一台服务器上。在服务端是存放着所有受控制数据的 Subversion 仓库，另一端是 Subversion 的客户端程序，管理着受控数据的一部分在本地的映射（称为 “工作副本”）。在这两端之间，是通过各种仓库存取层（Repository Access，简称 RA）的多条通道进行访问的。这些通道中，可以通过不同的网络协议，例如 HTTP、SSH 等，或本地文件的方式来对仓库进行操作。

```
<span>e</span><span>.</span><span>g</span><span>.</span><span>http</span><span>:</span><span>//www.am0s.com/admin/scripts/fckeditor.266/editor/.svn/entries</span>

```

**漏洞利用:**

工具：

[dvcs-ripper](https://github.com/kost/dvcs-ripper)

PHP

```
<span>rip</span><span>-</span><span>svn</span><span>.</span><span>pl </span><span>-</span><span>v </span><span>-</span><span>u http</span><span>:</span><span>//www.am0s.com/.svn/</span>

```

Seay-Svn

### 0x06 WEB-INF/web.xml 泄露

WEB-INF 是 Java 的 WEB 应用的安全目录。如果想在页面中直接访问其中的文件，必须通过 web.xml 文件对要访问的文件进行相应映射才能访问。

WEB-INF 主要包含一下文件或目录：

* ​`/WEB-INF/web.xml`​：Web 应用程序配置文件，描述了 servlet 和其他的应用组件配置及命名规则。
* ​`/WEB-INF/classes/`​：含了站点所有用的 class 文件，包括 servlet class 和非 servlet class，他们不能包含在 .jar 文件中
* ​`/WEB-INF/lib/`​：存放 web 应用需要的各种 JAR 文件，放置仅在这个应用中要求使用的 jar 文件, 如数据库驱动 jar 文件
* ​`/WEB-INF/src/`​：源码目录，按照包名结构放置各个 java 文件。
* ​`/WEB-INF/database.properties`​：数据库配置文件

**漏洞成因：**

通常一些 web 应用我们会使用多个 web 服务器搭配使用，解决其中的一个 web 服务器的性能缺陷以及做均衡负载的优点和完成一些分层结构的安全策略等。在使用这种架构的时候，由于对静态资源的目录或文件的映射配置不当，可能会引发一些的安全问题，导致 web.xml 等文件能够被读取。

**漏洞检测以及利用方法：**

通过找到 web.xml 文件，推断 class 文件的路径，最后直接 class 文件，在通过反编译 class 文件，得到网站源码。
一般情况，jsp 引擎默认都是禁止访问 WEB-INF 目录的，Nginx 配合 Tomcat 做均衡负载或集群等情况时，问题原因其实很简单，Nginx 不会去考虑配置其他类型引擎（Nginx 不是 jsp 引擎）导致的安全问题而引入到自身的安全规范中来（这样耦合性太高了），修改 Nginx 配置文件禁止访问 WEB-INF 目录就好了： location ~ ^/WEB-INF/* {deny all;} 或者 return 404; 或者其他！

### 0x07 CVS 泄漏

**漏洞利用**

测试的目录

PHP

```
<span>http</span><span>:</span><span>//www.am0s.com/CVS/Root 返回根信息</span><span>
http</span><span>:</span><span>//www.am0s.com/CVS/Entries 返回所有文件的结构</span>

```

取回源码的命令

PHP

```
<span>bk clone http</span><span>:</span><span>//www.am0s.com/name dir</span>

```

这个命令的意思就是把远端一个名为 name 的 repo clone 到本地名为 dir 的目录下。

查看所有的改变的命令，转到 download 的目录

PHP

```
<span>bk changes</span>

```

### Bazaar/bzr

工具：

[dvcs-ripper](https://github.com/kost/dvcs-ripper)

```
<span>rip</span><span>-</span><span>bzr</span><span>.</span><span>pl </span><span>-</span><span>v </span><span>-</span><span>u http</span><span>:</span><span>//www.am0s.com/.bzr/</span>

```

工具推荐

---

* [Bitkeeper](http://www.bitkeeper.com/installation.instructions)
* [weakfilescan](https://github.com/ring04h/weakfilescan)

|参考|
| ------|

* [https://zhuanlan.zhihu.com/p/21296806](https://zhuanlan.zhihu.com/p/21296806)
* [http://www.s2.sshz.org/post/source-code-leak/](http://www.s2.sshz.org/post/source-code-leak/)

转载: http://www.am0s.com/ctf/175.html


