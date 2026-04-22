---
title: "第二届盘古石杯决赛 WP"
date: 2025-05-13 00:43:00
disableNunjucks: true
---
# 第二届盘古石杯决赛 WP

### 手机取证

##### 1、分析安卓手机检材，空闲的磁盘空间是多少：[答案格式：3.12GB][★☆☆☆☆]

查看手机内文件，Adlockdown.[json](https://so.csdn.net/so/search?q=json&spm=1001.2101.3001.7020) 可以查看到手机是总存储和使用存储

![](https://i-blog.csdnimg.cn/blog_migrate/b90ce8e053b31ab47e1dacc32598c8f8.png)

计算一下就可以啦

![](https://i-blog.csdnimg.cn/blog_migrate/bcb2782485c9a436d5cabc9898042a64.png)

##### 2、分析安卓手机检材，蓝牙 MAC 地址是多少：[答案格式：11:22:d4:aa:38:1f][★☆☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/d0f4ed78280f9e533759fc2429ea1bd3.png)

##### 3、分析安卓手机检材，吴某浏览过最贵的一双鞋子是多少钱：[答案格式：1234][★☆☆☆☆]

鞋子？？？刚拿到题目人是懵的。然后翻了翻分析结果，软件里面有[得物](https://so.csdn.net/so/search?q=%E5%BE%97%E7%89%A9&spm=1001.2101.3001.7020)，这不果断进去看看。找到了我想要的数据的 json 文件。

![](https://i-blog.csdnimg.cn/blog_migrate/2e80878bd6a5bd8ddb2fc277eca98be4.png)

![](https://i-blog.csdnimg.cn/blog_migrate/204618c8aff6998f0fe966b28f650bc1.png)

在里面找找最贵的鞋子。不过让我最感觉奇特的是 "price": 165900, 这玩意后面两个 00 是小数点后两位，所以实际价格为 1659

![](https://i-blog.csdnimg.cn/blog_migrate/52ab8c451b47ec8ce88c0882514c1355.png)

通过[模拟器](https://so.csdn.net/so/search?q=%E6%A8%A1%E6%8B%9F%E5%99%A8&spm=1001.2101.3001.7020)仿出来，确实是后面的数字是小数点后两位。![](https://i-blog.csdnimg.cn/blog_migrate/8fac9fc960ed3ab35229c6fbb2639280.png)

##### 4、分析安卓手机检材，手机中最高版本的安卓虚拟机的 wifi_mac 是：[答案格式：11:22:d4:aa:38:1f][★★★☆☆]

ot01 的安卓版本

![](https://i-blog.csdnimg.cn/blog_migrate/ca74529272fb356b55683563499cc8fd.png)

ot02 的版本

![](https://i-blog.csdnimg.cn/blog_migrate/871b88e52cdcd56c44d8305512cb2cdb.png)

所有要看 ot01 的 WiFi mac

![](https://i-blog.csdnimg.cn/blog_migrate/baa8ac71c5b375d8e827cd1d0c0db78f.png)

##### 5、分析安卓手机检材，发现在安卓虚拟机中使用浏览器最早保存的书签地址是：[答案格式：https://baidu.baidu.com/n/5555579038?ent_id=1][★★★☆☆]

手机中有两个浏览器，对比一下，悟空浏览器时间更早。

![](https://i-blog.csdnimg.cn/blog_migrate/db195e6bbc0df04c76df6744028709ea.png)

##### 6、分析安卓手机检材，发现在安卓虚拟机中使用浏览器最后一次的访问地址是：[答案格式：https://baidu.baidu.com/naa-1-1231.html][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/41a2dcc757307dc6284593d48aafc3bb.png)

##### 7、分析安卓手机检材，手机中远程控制软件的密码是：[答案格式：aNdy][★☆☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/e967702d3adf2e9d81df18fc21a2c3a7.png)

##### 8、分析苹果手机检材，手机中安装的第三方 APP（排除系统应用）的数量合计是：[答案格式：1][★☆☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/3f14734e94e915f15c5b562ea43ee470.png)

##### 9、分析苹果手机检材，吴某尝试登录 telegram 应用所使用的手机号码是：[答案格式：13800138000][★☆☆☆☆]

tg 那就进应用目录看看

![](https://i-blog.csdnimg.cn/blog_migrate/1f9204946bfb2945005d000714173821.png)

翻了半天数据库都没有数据，然后发现了 Snapshots 文件夹，难道是在截图里面？

![](https://i-blog.csdnimg.cn/blog_migrate/e2a25a6c08988e3fdd88d420255d3377.png)

进去一堆 ktx 文件，双击还可以预览好评。尝试了火眼，不行（但是两个厂商的软件都有一个可以看全部软件的应用快照的地方）。

![](https://i-blog.csdnimg.cn/blog_migrate/c3dce556077bfbb9d2536eb83f672e2b.png)

##### 10、分析苹果手机检材，吴某是从什么 iOS 版本升级到当前版本的：[答案格式：14.4.1][★★★☆☆]

先看看当前版本

![](https://i-blog.csdnimg.cn/blog_migrate/848f2176a9b726d6c00dfdc69c44420e.png)

然后在分析内容中，找到了更新与还原日志

![](https://i-blog.csdnimg.cn/blog_migrate/e5385578f45d4f59ce7770e8a9e82eab.png)

进文件里面瞧瞧。发现有个日志文件，打开看看。

![](https://i-blog.csdnimg.cn/blog_migrate/79c1b99316b3fc4ec6718b5e06b15c1b.png)

里面确实有很多更新的日志，先搜搜当前版本看看。

![](https://i-blog.csdnimg.cn/blog_migrate/6a8481b9fa7c4baf3b4dc5875b8d8127.png)

上面是 os 版本，应该是更新包信息，下面显示的是操作系统的版本。所有上个版本应该是 16.0.3

##### 11、分析苹果手机检材，手机相册中的照片中，有多少张时通过 iPhone8 手机拍摄的：[答案格式：1][★★☆☆☆]

导出 Photos.sqlite，使用 navicat 打开，直接在数据库中搜索 iphone 8，秒杀。

![](https://i-blog.csdnimg.cn/blog_migrate/c11757fa6292f8d487cc2104415f7dbc.png)

![](https://i-blog.csdnimg.cn/blog_migrate/e8d9aebcf3ab7d233628ed35b748fc1b.png)

##### 12、分析苹果手机检材，手机曾开启热点，供其他人连接，分析手机开启的热点连接密码是：[答案格式：123adb][★★★☆☆]

有密码，肯定会走 wpa，但是不知道是什么版本，那就直接搜吧。

![](https://i-blog.csdnimg.cn/blog_migrate/084ce7d062f83bc4b29769027bbe43d0.png)

排除上面一大堆流文件，看看剩下的。

![](https://i-blog.csdnimg.cn/blog_migrate/97788b66b3d0aa26941bc4306c0c36c5.png)

这里面东西挺像。密码也有。

##### 13、接上题，分析成功连接到手机热点的手机型号是：[答案格式：HUAWEIP40i][★★★☆☆]

热点嘛，肯定会提供 DHCP 服务，看看 DHCP 的日志就好

![](https://i-blog.csdnimg.cn/blog_migrate/962b2b7e4852f56e2424c20f6536deeb.png)

##### 14、分析苹果手机检材，吴某曾连接过阿里云服务器，并将服务器的宝塔面板信息保存在手机上，请问该阿里云服务器的内网 IP 地址是：[答案格式：127.0.0.1][★★☆☆☆]

说到宝塔，能想到关键词：宝塔、BT、panel，用这几个搜一下。

![](https://i-blog.csdnimg.cn/blog_migrate/f7155358c5897aeca57dd2676400da25.png)

### APK 取证

##### 1、分析安卓手机检材，手机中创建了几个安卓虚拟机：[答案格式：3][★☆☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/17123f1379aa8ef87d2084eb8130ca92.png)

路径下有两个镜像文件

##### 2、分析安卓手机检材，手机中安卓虚拟机下载了几个 ROM：[答案格式：3][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/7100909bb898309d1cbcb0cd4a8daaea.png)

##### 3、分析安卓手机检材，发现在有几张图片是通过 AI 生成的，这些图是哪个应用生成的，写出该应用安装包的完整路径：[答案格式：/data/app/baidu.app-LLwjwKjpV8sNuMMYnuet3Q==/base.apk][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/53798590834eff171074f55281d1b225.png)1

知道名称就在应用列表里面搜一下就好

![](https://i-blog.csdnimg.cn/blog_migrate/847c380dd06e1f75fb9e10c0ac5746ed.png)

##### 4、分析安卓手机检材，屏幕截图 2023-06-01 141051.png 这个图片来自哪个应用，请写出应用的包名：[答案格式：com.tencent.mm][★★★★★]

直接搜索一把梭，

![](https://i-blog.csdnimg.cn/blog_migrate/a40e32027d44b2914980980c13135614.png)

在看看安装验证一下。

![](https://i-blog.csdnimg.cn/blog_migrate/ebae1d1aa9f269ec3a9e39e664f8f9e0.png)

##### 5、分析安卓手机检材，屏幕截图 2023-06-01 141051.png 这个图片的发送者名称是：[答案格式：Andy Oge][★★★★☆]

既然都知道是啥软件了，直接去软件目录看看，

![](https://i-blog.csdnimg.cn/blog_migrate/c4a3b6e42bc0e21ce35e3b149a411c09.png)

发现了一个 xml 文件，里面标注了接受历史，是 base64 编码，解码看看

![](https://i-blog.csdnimg.cn/blog_migrate/e29f62d7553b7a97955048a328a157bf.png)

里面有一个发送者名称

### IPA 取证

##### 1、警方在勘验苹果手机时，发现手机中有一个叫 “私密空间” 的应用。该应用打开需要密码，请分析苹果手机检材，该应用的打开密码是：[答案格式：123456][★★☆☆☆]

说什么软件就看什么软件，进软件目录看看

![](https://i-blog.csdnimg.cn/blog_migrate/2f7386b8d01a8a5a4ae9b97e5e59506c.png)

在目录中到处找，最后找到了

![](https://i-blog.csdnimg.cn/blog_migrate/a845294bd8dd1713c916b5047abddde4.png)

或者更加直接的是，直接 winhex 进行搜索

![](https://i-blog.csdnimg.cn/blog_migrate/3dd13b20ae6a90e48f330103490a6e58.png)

不过看应用的截图，发现密码应该是数字的，这个是加密后的密码。

![](https://i-blog.csdnimg.cn/blog_migrate/dc843e481b834103b11c4628aefbea11.png)

丢 cyber 里面直接就智能解出来了。

##### 2、接上题，分析该应用中一共加密了多少张图片：[答案格式：1][★★★☆☆]

打开了 SBMedia 数据库，里面只有一条记录。

![](https://i-blog.csdnimg.cn/blog_migrate/43b2c4fb49a775c2e1db3dd3c59849d1.png)

，然后查看生成加秘密的文件夹，确实也只有一个。

![](https://i-blog.csdnimg.cn/blog_migrate/472e3745a89ad150558d20338fe21098.png)

不过感觉应该还有，一般不会和答案格式一样的。不过确实找不到了。

##### 3、接上题，解密被加密图片，图片中记录的密码是：[答案格式：123adC][★★★★☆]

这个题确实不会，IPA 逆向真不会，连 IPA 包都导不出来。

##### 4、警方在勘验苹果手机时，发现手机中还有一个基于屏幕使用时间功能扩展的应用，该应用打开也需要密码，分析手机检材，该应用的打开密码是：[答案格式：123456][★★☆☆☆]

搜了一下 time，发现没东西呀，都是苹果自带的。那只有挨个看了。

![](https://i-blog.csdnimg.cn/blog_migrate/804e4329e269534b63110a6f48dcf36f.png)

![](https://i-blog.csdnimg.cn/blog_migrate/595c8fab5f5ea61d41752544c7f2825d.png)

究极筛选大法，好像 Cloak 不知道是啥。估计就是题目说的了。

那进目录看看，结果啥都没有，只有到处找一下了。

![](https://i-blog.csdnimg.cn/blog_migrate/47a0071064007c31a2a04d857e108ba2.png)

发现还有个共享目录，可以去瞅瞅。

![](https://i-blog.csdnimg.cn/blog_migrate/f38bccc3fee23c059e618039f3a5ebae.png)

在里面发现了 passcode，大概率应该是密码。

##### 5、接上题，该应用隐藏了多少个 APP：[答案格式：1][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/0ef39d887868929b424d54c35b5e3ce9.png)

有应用的 token，每个应用只有一个，所以应该有两个。

##### 6、接上题，该应用限制了位置信息，通过分析，设定的位置所属的城市是：[答案格式：北京][★★★☆☆]

在共享目录中有大量的日志文件。翻翻

![](https://i-blog.csdnimg.cn/blog_migrate/04b871f19fb848b58dba1a32eacd4824.png)

发现了一个成都的地理位置。

##### 7、审讯时，吴某交代其有通过手机中的某个应用对服务器数据库进行维护的习惯，分析苹果手机检材，给出该应用的应用名称：[答案格式：微信][★★☆☆☆]

维护能干嘛嘛，就能运行就只需要备份。那就搜搜 backup 试试。

![](https://i-blog.csdnimg.cn/blog_migrate/6cd11f7bce07ef06508381b6623d0b41.png)

找到一个，看看详细内容

![](https://i-blog.csdnimg.cn/blog_migrate/c9c62d3829f8f0074fd75ebd02ba5da0.png)

![](https://i-blog.csdnimg.cn/blog_migrate/158f52734be05bb0df8301feaa29b6a9.png)

这里面有服务器的连接 IP 和账号密码，大概率是连接上之后，进行备份脚本的执行。

##### 8、接上题，该应用对服务器数据库的操作，一共需要多少步操作：[答案格式：1][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/8deece0d62405462c9fd1d83bd3cbe44.png)

##### 9、接上题，上述操作过程中，一共涉及几个变量：[答案格式：123456][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/9969bb0cf3d1dc2d51dcb3b59c3cb201.png)

##### 10、接上题，该服务器的 IP 地址是：[答案格式：127.0.0.1][★★★☆☆]

IPA 太难了，已经累了，求教。

##### 11、接上题，上述操作过程中，生成备份文件的压缩密码是：[答案格式：123adb][★★★★★]

##### 12、继续分析该应用，该应用在相册中一共生成了多少张图片：[答案格式：1][★★☆☆☆]

##### 13、继续分析该应用，吴某通过该应用还获取了一个 APK 的下载链接地址，请问该 APK 的下载链接地址中包含的时间戳是：[答案格式：20240605][★★★★☆]

### 区块链分析

##### 1、通过 3D 案情，得到另一个钱包地址，请问地址是：[答案格式：0xasl23dfh232uhi4u23iuhi2u323kj2][★★☆☆☆]

看不了 3D 案情，呜呜呜。

##### 2、钱包地址信息对应哪一条公链：[答案格式：ETC][★★☆☆☆]

##### 3、钱包地址接受用户资金使用的虚拟币币种是：[答案格式：ETC][★★☆☆☆]

##### 4、已知地址 0xd109046aa3e92d13fad241a695262be4ec3431f6 曾收到上述地址涉案资金并将这笔资金后续跨链转出，跨链资金直接转出到哪条链：[答案格式：EtC 链][★★☆☆☆]

##### 5、根据上题，确定项目的沉淀地址是：[答案格式：Easl23dfh232uhi4u23iuhi2u323kj2][★★☆☆☆]

### 计算机取证

##### 1、分析计算机检材，计算机共通过 localsend 应用接收了多少个视频文件：[答案格式: 28][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/b1bb29da756ca5f3e7e9db26266c92d0.png)

找到该软件的数据文件

![](https://i-blog.csdnimg.cn/blog_migrate/d08bef58bdcd516ffbcd2393f78517c7.png)

搜索一下，69 项

##### 2、分析计算机检材，计算机共保存了多少个服务器的公钥：[答案格式: 28][★★★☆☆]

在计算机中发现了一个远程连接工具，打开看看

![](https://i-blog.csdnimg.cn/blog_migrate/c686b9284160db2e9b5589d0e12d34d4.png)

在其数据目录中发现存储了 hosts 信息

![](https://i-blog.csdnimg.cn/blog_migrate/e25695889ce941dc96e5b03dd4fab8e5.png)

打开即可，看见有 35 行即 35 个。

![](https://i-blog.csdnimg.cn/blog_migrate/24b1b5e180b1daa74bb91c62dafc70a5.png)

##### 3、分析计算机检材，计算机的 rustdesk 的中继服务器 IP 地址是什么：[答案格式: 123.123.123.123][★★☆☆☆]

直接一个仿真

![](https://i-blog.csdnimg.cn/blog_migrate/b6f4597c7218adfa6ecad4a9bfd82cb9.png)

##### 4、分析计算机检材，计算机的 TOR 浏览器记录第一个有 cookie 的暗网地址是：[答案格式: `http://sjiajjaksd.onion`][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/9847ee54545b743b4019acdb399c491b.png)

这不 666 暗网导航吗

##### 5、分析计算机检材，计算机里共群控过多少个终端：[答案格式: 28][★★★★★]

![](https://i-blog.csdnimg.cn/blog_migrate/8599c87fc818d71c1f38fb17e6303440.png)

电脑中找到的群控手机终端设备的软件。其`C:\Users\Administrator\Documents\laixi`​中数据库中有 4 个被控设备。

##### 6、分析计算机检材，吴某未被起获的另一部手机的真实型号是：[答案格式: oppo-A93][★★★★★]

![](https://i-blog.csdnimg.cn/blog_migrate/ac161989ca121db7333795ac691319d6.png)

被起获的手机为吴的 S21+

![](https://i-blog.csdnimg.cn/blog_migrate/063538e839adebbe99c7441d1294e274.png)

在电脑接入的 USB 设备中，还有一部 Galaxy Z Fold5

![](https://i-blog.csdnimg.cn/blog_migrate/294c75fe38ce9b858fa2b6b63fdfa68a.png)

起获手机的型号，

![](https://i-blog.csdnimg.cn/blog_migrate/570f22282bc20625f2c1487e8f6fc38e.png)

然后再电脑中找到一个 laixi.db，这个是群控手机的脚本软件。

![](https://i-blog.csdnimg.cn/blog_migrate/3f3c9d0f531d3de4432e31c06f1761f1.png)

里面 SM 开头的为三星的设备，除去起获的，就是第四个未被起获的。所以按照答案格式为 SM-F9460

##### 7、分析计算机检材，计算机群控程序脚本中哪个是吴某自己写的，文件名是：[答案格式: scripts.txt][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/f5b3c6f5afc860014bfbeaccd57df019.png)

这是脚本的信息，到存储位置查看

![](https://i-blog.csdnimg.cn/blog_migrate/7b5b818ce55e59cb6e5dbe367f10e838.png)

发现多出来一个，应该是自行编写。

##### 8、分析计算机检材，计算机群控程序中滑屏脚本最大滑屏次数是：[答案格式: 28][★★★★☆]

![](https://i-blog.csdnimg.cn/blog_migrate/92200ea33a202dfaf4611d99973f3705.png)

直接看代码的循环，发现循环会走 9999 次，但是循环外还执行了一次，所以滑屏次数为 10000。

##### 9、分析计算机检材，计算机中 adb 程序环境变量目录是：[答案格式: C:\Program Files\test.exe][★☆☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/6fe6a0595b7f9489e343eda4e299c4cf.png)

##### 10、分析计算机检材，微信聊天中的虚拟钱包地址是：[答案格式: TJ4HGPcdXD3d5397hFEPdpdukTY38DDh8o][★☆☆☆☆]

利用内存镜像解密微信聊天记录

![](https://i-blog.csdnimg.cn/blog_migrate/51c08c1d94a20507213a87007de1b6a3.png)

##### 11、分析计算机检材，容器程序 main 函数地址是：[答案格式：0X4012000E1][★★☆☆☆]

找了半天，结果容器程序就是这个别点我。。。逆向也还方便，毕竟自带逆向工具，直接导入 ida

![](https://i-blog.csdnimg.cn/blog_migrate/755345bc25e3cd459f09d9546800d9c7.png)

查看 start，地址是 0X1400010E0

##### 12、分析计算机检材，容器程序导入函数总数是：[答案格式：123456][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/6882bf45b8f635c7a5bc555c37146baf.png)

这个 IDA 也可以直接查看，82 个。

##### 13、分析计算机内存检材，给出进程 “别点我. exe” 的进程 ID 是：[答案格式：123][★☆☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/27763a704d21412aed5342cee2aae98f.png)

火眼差评哈，加载不出来中文，不过可以看模块列表，里面的中文是显示的

##### 14、分析计算机内存检材，FTK Imager 的程序版本号是：[答案格式：1.2.3.4][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/eb6eb44bc884d35a1c94db618fcc5408.png)

将 FTK 文件导出（当然可以直接导 exe 文件）我难得输了

![](https://i-blog.csdnimg.cn/blog_migrate/9da5258fc6302a719769e63b4fb27cfe.png)

导出来之后，直接看详细信息就 OK。

##### 15、分析计算机内存检材，给出向日葵使用时，计算机内网的 IP 地址是：[答案格式：127.0.0.1][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/17a8fd0023644a72efd906e1c73c1dc8.png)

### 数据分析

##### 1、分析计算机检材，户籍是黑龙江省的受害人总数是：[答案格式：123456][★★★★☆]

真不知道密码，难道在 3D 案情里面？又打不开，只有放弃

##### 2、分析计算机检材，受害人住址地跟户籍地不在一个省份的总是：[答案格式：123456][★★★★☆]

##### 3、分析计算机检材，受害人年纪在 25 岁以下和 60 岁以上总数是（以当天为准）：[答案格式：123456][★★★★☆]

##### 4、分析计算机检材，住址在四川的受害人余额总计：[答案格式：123456][★★★★☆]

##### 5、分析计算机检材，男性受害人总数是：[答案格式：123456][★★★★☆]

##### 6、分析计算机检材，注册时间在 2024 年 1 月 1 号到 2024 年 4 月 1 号的受害人总数是：[答案格式：123456][★★★★☆]

### 入侵分析

##### 1、分析 V 服务器，网站 http://192.168.11.89 在网站根目录存在源码泄露的位置是：[答案格式：/houtai/test.tar][★★☆☆☆]

道理我都懂，为啥没有其他用户还会在 home 目录里面藏东西啊，不应该在 / root 目录下吗？还不给 history。找了半天。

![](https://i-blog.csdnimg.cn/blog_migrate/f71cd9846f9f8353914785e2127366bc.png)

最后是这样才知道的。。。看了才知道，原来是目录爆破的扫描结果，看一下扫描出来的东西。

![](https://i-blog.csdnimg.cn/blog_migrate/df96369ace1480dda26fa6129ac2f605.png)

发现有一个 www.zip 的包返回是 200，其他的可能性不大，所以答案是 / manage/www.zip

##### 2、分析 V 服务器，在网站根目录存在源码泄露的网站是：[答案格式：10.45.78.46][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/d0f2e6d4faa6b7af0b82a2363dba925f.png)

查看日志，发现另一个网站也有类似的泄露情况

##### 3、分析 V 服务器，黑客使用 os-shell 写入文件上传内容的文件名是：[答案格式：test.php][★★★★☆]

我这个暴脾气，不想到处翻了，直接导出来正则筛选

![](https://i-blog.csdnimg.cn/blog_migrate/3f776d94c82750c3595f7b4046ec60f3.png)

我们要看日志，CPP 排除，dirsearch 没有上传功能，那就是 sqlmap。点开文件看看

![](https://i-blog.csdnimg.cn/blog_migrate/8f28e3f629dc856a692a0c70b2f69438.png)

这不就找到了吗

##### 4、分析 V 服务器，正在使用的 XSS 平台中接受到哪个网站的管理员的 cookie：[答案格式：`http://www.baidu.com`][★★★☆☆]

XSS 平台，其实刚才网站都搭好，进去都找了半天了。这个网站好搭得一批，除了需要修改一下 IP。因为网站限制 IP 为 192.168.11.188，其实也就是工作 IP 为这个，需要修改虚拟机 IP 段，或者修改网站 config.conf 文件。

![](https://i-blog.csdnimg.cn/blog_migrate/62c5dcfe7fdf0bc16983d9e5f1ddeb27.png)

所以网站为：http://jinsha.abc

##### 5、分析 V 服务器，获取到权限的目标机器的管理员 NTLM 是：[答案格式：45ry56gfr5dtt6ytyh6y93875ufha7f5][★★★☆☆]

既然有 cookie 应该用工具连接了，提权那肯定是 CS 啦。直接在文件中搜索 NTLM。

![](https://i-blog.csdnimg.cn/blog_migrate/5ecb4d064e69ee3c4d0e6a3bc43fd7c7.png)

就可以发现其的值。同时也找到了日志文件位置。

##### 6、分析 V 服务器，从获取到权限的目标机器上下载了哪个文件：[答案格式：D:\system\network\test.txt][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/b6e4d96e18eff61936432bafc0769953.png)

在日志中发现下载了 config.php 文件。

##### 7、分析 V 服务器，在获取到权限的目标机器成功创建的用户名是：[答案格式：test][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/0eba5d3cd617dcd62a6979fbf7d13829.png)

发现创建用户的命令，第一个创建失败，第二个成功，所以创建的是 leon$

##### 8、分析计算机检材，共对多少个网站进行过 SQL 注入的漏洞尝试：[答案格式: 28][★★☆☆☆]

又回到了计算机，到处跑。先看看 sqlmap 的根目录下有没有东西，发现没有，那还是只有去 appdata 里面看看了。直接就找到了 sqlmap 的 output 文件，里面一共 17 项。

![](https://i-blog.csdnimg.cn/blog_migrate/237228942ea60b0e8da911c31813f10e.png)

##### 9、分析计算机检材，通过 sql 注入成功获取了一个网站的大部分数据，存在注入漏洞的参数是：[答案格式: id_id][★★★☆☆]

查看文件，发现 gg.aigua666.com 网站记录中，有 dump 下来的网站数据，所以这个就是题目中提到的网站

![](https://i-blog.csdnimg.cn/blog_migrate/b771ea64a48e9c361ccf96062284092d.png)

查看日志，其 payload 注入点为 c_usd。

![](https://i-blog.csdnimg.cn/blog_migrate/bd8b50e4013f254750deee2290865ee5.png)

##### 10、分析计算机检材，通过 sql 注入成功获取了一个网站的大部分数据，吴某攻击的网站管理员的登录 IP 是：[答案格式: 23.44.13.56][★★★☆☆]

其中有个管理者的表，打开看就可以找到管理员 IP

![](https://i-blog.csdnimg.cn/blog_migrate/028e620fbbc30b420a546c3753dd2560.png)

##### 11、分析计算机检材，电脑上共连接过多少个 webshell：[答案格式: 123][★★★★☆]

![](https://i-blog.csdnimg.cn/blog_migrate/168b0edbb93cf29aa084208b184fcdef.png)

![](https://i-blog.csdnimg.cn/blog_migrate/1087ab3ec769e7508971fbb73e6d146c.png)

webshell 工具看了一圈，发现蚁剑还有冰蝎有连接过，总共 14 个。

##### 12、分析计算机检材，电脑上常用的 mo 蚁剑共安装了多少个插件：[答案格式: 123][★★★☆☆]

直接在插件设置那个里面数了一下，一共 27 个。
![](https://i-blog.csdnimg.cn/blog_migrate/93d98e46454f5df688aef9f8d3596842.png)

##### 13、分析计算机检材，电脑上常用的蚁剑做了改造，改造后的 User-agent 是：[答案格式: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us)][★★★★☆]

先进开发者模式，然后查看控制台，通过控制台获取 User-Agent

![](https://i-blog.csdnimg.cn/blog_migrate/f7c2248c022111a8e8946d7339694608.png)

![](https://i-blog.csdnimg.cn/blog_migrate/84d842138dd1a2d4a952fdbdea3f6d7b.png)

##### 14、分析计算机检材，吴某在后门为 con.php 的 webshell 上查询到 / www/wwwroot/default / 目录下有多少个 php：[答案格式: 28][★★★★★]

查看蚁剑的数据库文件

![](https://i-blog.csdnimg.cn/blog_migrate/206c537575bde73161f841406649ce7f.png)

![](https://i-blog.csdnimg.cn/blog_migrate/483f789e13cf8b671a7d4ce783d9b595.png)

提取 con.php 对应的条目，查看详细信息，找到对应的 ID

![](https://i-blog.csdnimg.cn/blog_migrate/f2b151d686bfe7d759e9d47bee24d031.png)

查看 cache 中对应文件。

![](https://i-blog.csdnimg.cn/blog_migrate/8654d71a940b3b1aa62ee4f22746b497.png)

搜了一下. php 结尾的文件，发现有 434 个。

##### 15、分析计算机检材，吴某通过手机 kali 渗透后拿到一个 webshell，使用电脑进行管理，这个 webshell 主机的计算机名是：[答案格式: U8FJ3SH41S5HD][★★★★★]

kali，手机，但是不是 nethunter，那应该是 termux 里面的，去 data 目录中看看。kali 中工具太多，不好找，但是既然是电脑中管理，那么肯定是在 webshell 中，用 webshell 涉及的几个 IP 进行搜索。

![](https://i-blog.csdnimg.cn/blog_migrate/ee26c58c0b5cb8790007e0d05d60616d.png)

其中 10.0.0.10 是本地 ip，不用看，剩下的就只有 112.124.62.187。然后看了一下主要是 sqlmap 的使用记录。其中有 sqlmap 利用的 POST 文件。那么大概率就是这个 IP 了，那么查看冰蝎，用离线模式打开。

![](https://i-blog.csdnimg.cn/blog_migrate/800a0f4f70b935faaf9ebaf5de004113.png)

就可以发现电脑名称。

##### 16、分析计算机检材，吴某通过手机 kali 渗透后拿到一个 webshell，使用电脑进行管理，这个 webshell 主机当前登录操作系统的用户名是：[答案格式: admin][★★★★★]

![](https://i-blog.csdnimg.cn/blog_migrate/9648278d829370888e5cec728f232adb.png)

##### 17、分析计算机检材，吴某通过手机 kali 渗透后拿到一个 webshell，使用电脑进行管理，这个 webshell 主机的数据库密码是：[答案格式: Pssword][★★★★★]

要连 webshell，做不来啦

##### 18、分析计算机检材，吴某通过手机 kali 渗透后拿到一个 webshell，使用电脑进行管理，吴某成功提权使用到的工具名是：[答案格式: Tiquan.exe][★★★★☆]

##### 19、分析计算机检材，吴某在电脑上使用 CobaltStrike 生成了一个木马，该木马的 MD5 值是：[答案格式: sdfs2342v42cvh342h][★★★☆☆]

打开 CS 看看

![](https://i-blog.csdnimg.cn/blog_migrate/ff5bcea51a1cc42e5506cd0f2bf130b2.png)

这不就是 V 服务器吗？不过我改了 IP，然后这个也得改一下。然后去服务器看看 CS 的目录。

![](https://i-blog.csdnimg.cn/blog_migrate/6efe25f38fc0b311744787f16e780fee.png)

这个应该是 CS 搭的服务器，然后启动一下。启动方式：`./teamserver [192.168.11.188](IP) [123456](密码)`​

![](https://i-blog.csdnimg.cn/blog_migrate/191ce8c6960740363655cbb50279e543.png)

然后连接上看看。发现有一个目标。

![](https://i-blog.csdnimg.cn/blog_migrate/7e0b379988f3b0fc8c42c32bedd60bc7.png)

查看 CS 的日志。

![](https://i-blog.csdnimg.cn/blog_migrate/7588471d7be745bbc3dfbf9b40c95fb2.png)

发现是连接是通过 Wechat.exe 连接的。然后在电脑中查找，发现了该程序。

![](https://i-blog.csdnimg.cn/blog_migrate/f8804e41d97afa5f3a37f863a1ae173d.png)

![](https://i-blog.csdnimg.cn/blog_migrate/dea9c5c7e854adee567beb7e3bb766b1.png)

##### 20、分析计算机检材，吴某在电脑上进行了内网渗透，socks5 协议跳板代理服务器的 IP 以及端口是：[答案格式: 12.34.56.78:7890][★★★☆☆]

电脑中有一个 Pro【无视我】xifier 软件，是用来代【无视我】理的，打开查看。

![](https://i-blog.csdnimg.cn/blog_migrate/16991ce1455b75b3a07efa8da8af5c3c.png)

##### 21、分析计算机检材，吴某在对目标进行信息收集时发现了一些 Webpack 等前端打包工具所构造的网站，使用特定工具对其进行信息收集，该工具共输出多少个网站的报告：[答案格式: 28][★★★☆☆]

信息收集的话，那直接查看信息收集的软件，

![](https://i-blog.csdnimg.cn/blog_migrate/09b77bced6741cf1f5eb5dd4f6cff9af.png)

发现 PackerFuzzer 软件，这个是用来扫描 webpack，打开文件目录查看，在 tmp 文件中发现了 reports 文件夹，进去看看。

![](https://i-blog.csdnimg.cn/blog_migrate/fd7e9e5852a7e6a89ee751968812c82f.png)

发现有 5 个 docx 即 5 个报告。

##### 22、分析计算机检材，吴某使用远程登录工具登录了一台远程 windows 主机，其 IP 地址是：[答案格式: 12.34.56.78][★★★☆☆]

在 PRemoteM 中发现了一个远程的。

![](https://i-blog.csdnimg.cn/blog_migrate/aebed0d5aa87f31dbdb85fdafae84831.png)

##### 23、分析计算机检材，吴某拖回了某台机器的 lsass 进程的内存，该机器的开机密码是：[答案格式: 7yjfom][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/84793e6ef997761f0583c1875c342bd2.png)

找到了对应程序，试了一下，会生成. dmp 后缀的文件，所以直接搜索一下，在 mimikatz 目录下有一个 mm.dmp 文件。所以直接用 mimikatz 跑一下密码试试。执行命令。

![](https://i-blog.csdnimg.cn/blog_migrate/7ba7bd8e7fb7b1eebe35dff7432ab83d.png)

可以得到密码。

![](https://i-blog.csdnimg.cn/blog_migrate/ca34ed3fed49995a7d732edd6d5f38d1.png)

##### 24、分析安卓手机检材，kali 开放的 ssh 端口是：[答案格式: 22][★★☆☆☆]

直接查看 sshd 的配置文件

![](https://i-blog.csdnimg.cn/blog_migrate/64b8dc26a62ba65cc0140e45002e441c.png)

##### 25、分析安卓手机检材，存在 sql 注入漏洞的网站网址是：[答案格式: `http://23.22.41.19:8888`][★★☆☆☆]

/home 目录下有个 sqlmap 目标文件，大概率是这个

![](https://i-blog.csdnimg.cn/blog_migrate/cbce285918ee4810cb9808864b9680d9.png)

![](https://i-blog.csdnimg.cn/blog_migrate/062606a2876dace9ca500bfba89a4b7d.png)

同时在 history 文件中，也可以发现，有运行后输出的目录，可以确定是这个。

##### 26、分析安卓手机检材，存在 sql 注入漏洞的网站的内网 IP 地址是：[答案格式: 12.34.56.78][★★★☆☆]

直接到输出的目录下查看 log 文件，可以发现里面有 IPv4 的地址

![](https://i-blog.csdnimg.cn/blog_migrate/3ce7793ac9b554a837920db6e43ff4a7.png)

##### 27、分析安卓手机检材，存在 sql 注入漏洞的网站服务器被添加了几个账户：[答案格式: 28][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/d3a5a06d9afee3feefbde5ad91a177c9.png)

用户有 5 个，其中系统自带 2 个，所以被添加的为 3 个

##### 28、分析安卓手机检材，存在 sql 注入漏洞的网站服务器上已有 webshell 的连接密码是：[答案格式: admin][★★★★☆]

在冰蝎中有对应 IP 的 webshell

![](https://i-blog.csdnimg.cn/blog_migrate/9e3a5e16018ef383efa9801ecdf24eed.png)

### 服务器取证

##### 1、分析 V 服务器，代…… 理软件登录的端口是：[答案格式：6376][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/cf3b806e7ca3d3492eab496b8952d2b4.png)

直接查看端口信息，可以发现 sing-box 服务。发现这两个端口都无法进入登录页面。

![](https://i-blog.csdnimg.cn/blog_migrate/452cc6e5fd41f226799859325a8cf92d.png)

又看到了 sui 服务，这个的端口是提供了 http 服务的。所以看看这个软件

![](https://i-blog.csdnimg.cn/blog_migrate/82c1d13741b5d7e62050f43b1b96c0dc.png)

发现了 s-ui 其实是 sing-box 的 ui 服务，所以找了一下，发现了 s-ui 的数据库。

![](https://i-blog.csdnimg.cn/blog_migrate/5205839838fccea314315ec7e0e5cbfb.png)

登录端口和地址就知道啦。

##### 2、分析 V 服务器，代【无视我】理软件中的代【无视我】理端口是：[答案格式：7837][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/a540ce2d91826c9ce547b7f1b8288ac8.png)

启动后会监听代【无视我】理，v2ray 监听的是自身 ip 应该不是，ss 走的是全 ip，还包括 tcp 和 udp，应该的代【无视我】理端口，所以应该是 41369

##### 3、分析 V 服务器，正在使用的 XSS 平台用 IP 运行的端口是：[答案格式：7843][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/c743f6fea6f3c76c5c9f8592dc7ceb2b.png)

直接上宝塔查看配置。

##### 4、分析 V 服务器，正在使用的 XSS 平台的管理员密码是：[答案格式：test][★★☆☆☆]

不知道密码，找了一下也没有找到。用 hashcat 跑一下试试。难得找字典了，比赛的时候还是建议用字典跑

![](https://i-blog.csdnimg.cn/blog_migrate/74f624664814b26fcd3fcfbd2d4ec1ba.png)

密码是 admin123

##### 5、分析 V 服务器，这台机器中的 cobaltstrike 服务端使用的端口是：[答案格式：7846][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/41ef0775e0590292fc211530a6848665.png)

入侵检测的时候就已经看到了，还已经连过，这个题就一点顺序都没有。

##### 6、请分析网盘服务器，吴某购买的 racknerd 服务器的详情 ID 是：[答案格式: 100001][★★☆☆☆]

先仿真，然后看看服务器中有啥。其中有 docker，那就进去瞧瞧。

![](https://i-blog.csdnimg.cn/blog_migrate/346c9e4ecd9ed9aa35d09bb97d4d4cde.png)

![](https://i-blog.csdnimg.cn/blog_migrate/c6c7cb458890e1e15d34ddb0fa02dd65.png)

嚯，还挺多，挨个进去瞧瞧，在 80 端口里面发现了相关字眼。

![](https://i-blog.csdnimg.cn/blog_migrate/25a0017abc4a85b08e158a0873f5fcd1.png)

看见链接里面包含 id=331979，这个就是啦。

##### 7、请分析网盘服务器，共有几个提供 web 服务的端口：[答案格式: 8][★★☆☆☆]

查看网络详情，发现了多个端口，挨着试一试，发现只有 8080、80、5244、3001 端口是有 web 响应的。但是 5344 这个东西访问不了，但是是 nodejs 搭建的，所以不知道算不算。

![](https://i-blog.csdnimg.cn/blog_migrate/e57b9da4e1bd16ba9fdba1114cc50425.png)

##### 8、请分析网盘服务器，admin 用户加密密码的盐值是：[答案格式: Password123][★★☆☆☆]

网站就俩需要登录，挨个看呗

5244 端口的

![](https://i-blog.csdnimg.cn/blog_migrate/b2e5d6b1b401cbdfbcec62986b27758e.png)

直接目录看看

![](https://i-blog.csdnimg.cn/blog_migrate/2de11ede18f5949dfa0b6ddc7b8dae25.png)

data 目录下有数据库文件，直接打开看看，salt 为 w4XKqQfHI89zdMXb。

![](https://i-blog.csdnimg.cn/blog_migrate/11b0f609fce684a822bc60ae882fd500.png)

##### 9、请分析网盘服务器，服务器存活监控应用的 admin 用户密码是：[答案格式: password123][★★☆☆☆]

上一题没有看另一个网站，这道题看过来了，这个 Uptime Kuma 就是个监控应用。直接上目录瞅瞅。

![](https://i-blog.csdnimg.cn/blog_migrate/05fb3bdbeb7a8d3b04dcc868a9fc4121.png)

挂载了一个目录上去，就直接查看这个目录就好。喏，数据库。

![](https://i-blog.csdnimg.cn/blog_migrate/acb509266abbca1754f4b5c4cf374bfe.png)

![](https://i-blog.csdnimg.cn/blog_migrate/13f0743804e1d839714294a11818a080.png)

进去直接看 user 表，里面的密码又加密了，让我们有请 hashcat

![](https://i-blog.csdnimg.cn/blog_migrate/ca7cbfa71a6dc9370913359590e0c780.png)

字典跑很快，密码就是 admin888。

##### 10、请分析网盘服务器，服务器存活监控应用中监控的论坛网址是：[答案格式: https://hackerblog.is][★★★☆☆]

用刚才得来的密码登录，发现有三个网站

![](https://i-blog.csdnimg.cn/blog_migrate/3b5749b165d696226d383895ba1ef95d.png)

灵戒是本地搭建所以不是，门罗币是交易市场，也不是。那只有 BF 了。

##### 11、请分析网盘服务器，服务器存活监控应用中使用的代理端口是：[答案格式: 8080][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/a2a4f47dc38295908084c5dbc8c1ce52.png)

##### 12、请分析网盘服务器，服务器存活监控应用中用来推送的 SendKey 是：[答案格式: CH88JJF8QWNC0WQJSNKQW9jaskd8sjj][★★★☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/2b511c4f98d9e48c0812923830b87d7c.png)

##### 13、请分析网盘服务器，用来加密网盘中压缩文件的加密算法是：[答案格式: RSA][★★★★☆]

先登录上去看看，发现 hash 值是在前端计算的，所以直接复制然后覆盖 admin 密码，就可以正常登录了。

![](https://i-blog.csdnimg.cn/blog_migrate/04a885dc651a32d14c7e0c50a20e61e4.png)

不过其实也不用登录，直接目录中就有。

看到有很多的压缩包，不过加密，这个里面好像木有。想起来，docker 中还有一个容器是 alist-encrypt，那么加密算法应该在这里面。

![](https://i-blog.csdnimg.cn/blog_migrate/d929a3f485e01ccb87fcfbd9354bcc9c.png)

![](https://i-blog.csdnimg.cn/blog_migrate/c8258a4c27848e32a27aec2dcd45e9bf.png)

再看看其绑定的目录，里面有一个 config.conf 文件

![](https://i-blog.csdnimg.cn/blog_migrate/a8a9c2a791decf6eb1313d97796d2291.png)

![](https://i-blog.csdnimg.cn/blog_migrate/00ec5ef080c2ef620f04b605ee4f68be.png)

类型是 rc4

##### 14、请分析网盘服务器，用来加密网盘中压缩文件的加密密码是：[答案格式: Password123][★★★★★]

见上题图

##### 15、分析网站服务器检材，数据库的 root 密码是：[答案格式：123abc][★★☆☆☆]

打开服务器一看，又有宝塔，进去瞅瞅，发现没有看见数据库配置，那直接进代码看看吧。

![](https://i-blog.csdnimg.cn/blog_migrate/db10b06ced8b9544ec16fd68d1217ee9.png)

找到了 database.php 发现密码在网站根目录的 env 中。

![](https://i-blog.csdnimg.cn/blog_migrate/ccc1e21e8f8b266f9c25ec18ddf327c6.png)

发现还不是，怎么办呢。又只有看宝塔了，发现是隐藏了数据库这个板块，打开后就可以看见 root 密码啦。

![](https://i-blog.csdnimg.cn/blog_migrate/cdd6e679acc8d8e693fc1023935d2444.png)

##### 16、分析网站服务器检材，嫌疑人预留的 QQ 号码是：[答案格式：123456][★★☆☆☆]

在网站中点击进一个商品

![](https://i-blog.csdnimg.cn/blog_migrate/9e3cb2efcaa788fe64cf7962c714524e.png)

##### 17、分析网站服务器检材，吴某预留的 tg 群组账号是：[答案格式：@abc][★★☆☆☆]

先进网站看看。需要登录，先看看数据库。

![](https://i-blog.csdnimg.cn/blog_migrate/417afecefd7969e212fdbe760abe6714.png)

这个加密一眼 bcrypt。其实找了代码，有点复杂，没有找到加密的地方。那么就直接生成一个，替换就是了。

![](https://i-blog.csdnimg.cn/blog_migrate/9b45781123b5057fb05708abfd685283.png)

![](https://i-blog.csdnimg.cn/blog_migrate/528d2e3b7048c65399a60676bb0a2da8.png)

登录成功，发现有个加入 TG 群，F12，看看网址

![](https://i-blog.csdnimg.cn/blog_migrate/341892e12fb051817fcbca4412b9e559.png)

那么群组账号就是 @yourcode

##### 18、分析网站服务器检材，源码交易平台一共提供了多少支付通道：[答案格式：123][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/78f41ba2c1e4af49514dd65774923634.png)

总共有 18 个，但是最后两个未启用，所以应该是 16 个

##### 19、分析网站服务器检材，当前服务器交易记录中，已完成的订单数量是：[答案格式：1][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/d185588b7b32fbdaa0f47b998f16d2ad.png)

只有 3 个为已完成。

##### 20、分析网站服务器检材，5 月 21 日期间，使用优惠码下单购买的产品中，买家填写的邮箱地址是：[答案格式：123@abc.com][★★★☆☆]

根据上题图，可以发现，没有符合条件的，然后序号没有 2，那肯定是删掉了，看一下数据库的目录

![](https://i-blog.csdnimg.cn/blog_migrate/8bb025e3b46c39b1105a87c54b2ca100.png)

binlog 日志也被删了，那只有看看 ib_logfile0 里面了。

![](https://i-blog.csdnimg.cn/blog_migrate/60ffc4e675991e43f61e6004c0740f43.png)

果不其然，被我找到了一个未在订单记录中出现的订单号。

![](https://i-blog.csdnimg.cn/blog_migrate/7fc3941fc5fde7c7952bdcc211df4229.png)

按照下面订单号 VRD6GR2NFSL0WIU 在数据库中保存的字段顺序是订单号——名称——邮箱，那上面 PRJ03Q5RAQZPUPWQ 的邮箱就应该为 1234587@qq.com。

##### 21、分析网站服务器检材，吴某通过即时通讯和买家联系后，买家下单的源码成交金额是：[答案格式：100][★★☆☆☆]

![](https://i-blog.csdnimg.cn/blog_migrate/51483b8d6f1a37c9ceb53f6f8bd66938.png)

![](https://i-blog.csdnimg.cn/blog_migrate/4d4f30bfa3568b7e0501f44016c45aba.png)

所以答案是 450。


