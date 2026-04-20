---
title: "校内培训：misc入门"
date: 2025-12-29 13:12:00
disableNunjucks: true
---
# 校内培训：misc入门

> 「如果一道题不适合放在其它的方向，那么 misc 永远能收留它。」 —— yixinBC
>
> 「每一个 misc 手都是一个隐藏的全栈✌。」 —— w3nx1z1

安全领域不止 Web、逆向等方向，Misc 涵盖了剩下的一些部分，同时也对一些强分类方向的细枝末节进行考查，像是对安全领域的碎片进行整理，因此称为「杂项（Miscellaneous）」。常见的 Misc 题型包括：编码、隐写、流量分析、压缩包分析、AI、取证、社会工程学、区块链、沙箱逃逸等等。

## 学习 Misc 的第一步

Misc 突出的就是庞杂，涉猎内容十分广泛。但也正因如此，一些知识点往往并不是很高深（至少入门是如此），请放心地搜索并学习它。

在 Misc 的道路上走得远些对其它方向是有些帮助的，你可能会享受那种使用奇技淫巧解决问题的快感，当然，更多的时间则是在与出题人对脑洞。

下面是一些你需要具备的基础能力：✌

* 极强的信息搜集能力，包括但不限于互联网搜索、文件信息收集、社会工程学等
* 对至少一门编程语言（最好是 Python）的掌握

## 常见题型及工具

### 编码

编码指的是将一个字符串通过某种法则变化为另一个字符串。常见的编码例如：

* ASCII 码
* Base 家族
* 古典密码
* 摩斯电码
* URL 编码
* MD5 加密
* 特殊编码：新旧佛曰、尊嘟假嘟、社会主义核心价值观编码等）

编码不止以上这些，甚至会包括一些游戏或动漫作品中的编码（如提瓦特文字、魔女之旅文字等），需要通过刷题等途径自行积累。

### 隐写

隐写术是一种将秘密信息隐藏在普通数据中的技术。在 CTF 竞赛中，Misc 类别通常涉及到各种隐写技巧，包括但不限于文本、图像和音频隐写。 隐写的种类有很多种，细化的方式也多种多样，例如：

* 图片隐写（[ImageMagick](https://github.com/ImageMagick/ImageMagick)）

  * 宽高隐写
  * EXIF 隐写（[MagicEXIF](https://www.magicexif.com/)、[ExifTool](https://github.com/exiftool/exiftool)）
  * LSB 图片隐写（[zsteg](https://github.com/zed-0xff/zsteg)、[StegSolve](https://github.com/Giotino/stegsolve)）
  * 盲水印（[BlindWaterMark](https://github.com/fire-keeper/BlindWatermark)、[WaterMark](https://cdn.openicu.net/utils/WaterMark.exe)）
  * GIF 帧隐写（GIF 帧提取网站、[ffmpeg](https://ffmpeg.org/) 等）
  * Montage+gaps拼图（[gaps](https://github.com/nemanja-m/gaps)、[montage](https://imagemagick.org/script/montage.php)）
  * F5 隐写（[F5 Steganography](https://github.com/matthewgao/F5-steganography)）
* 音频隐写

  * 频谱图隐写（[Audacity](https://www.audacityteam.org/)、Adobe Audition 等音频软件）
  * 波形隐写（[Audacity](https://www.audacityteam.org/)、Adobe Audition 等音频软件）
  * LSB 音频隐写（[SilentEye](https://achorein.github.io/silenteye/)）
  * 慢扫描电视（[MMSSTV](https://hamsoft.ca/pages/mmsstv.php)、[PySSTV](https://github.com/dnet/pySSTV)、[SSTV Decoder](https://github.com/colaclanth/sstv)）
  * MP3 隐写（[MP3stego](https://www.petitcolas.net/steganography/mp3stego/)）
  * Deepsound 隐写（[DeepSound-2.0](https://github.com/oneplus-x/DeepSound-2.0)）
* 文本隐写

  * 零宽隐写（[Unicode Steganography](https://330k.github.io/misc_tools/unicode_steganography.html)、[Zero-Width space steganography](https://offdev.net/demos/zwsp-steg-js)）
  * Snow 隐写（[SNOW](https://darkside.com.au/snow/)）
  * 空白格隐写（[Whitelips IDE](https://vii5ard.github.io/whitespace/)）
  * 宏病毒（[oletools](https://github.com/decalage2/oletools)）

隐写的方式往往不止于此，因为你所添加的数据（噪声）的分布函数可以是任意的。

### 压缩包

有时你会得到一个损坏或加密的压缩包，你需要获取压缩包中的内容。这就需要多种修复、攻击等技巧。

常见的压缩包考点有：

* 伪加密（使用 [010Editor](https://www.sweetscape.com/010editor/) 手动修改）
* CRC 爆破（[CRC_Cracker](https://github.com/Dr34nn/CRC_Cracker)）
* 明文攻击（[bkcrack](https://github.com/kimci86/bkcrack)）
* 暴力破解密码（[Passware Kit](https://www.passware.com/)、[Ziperello](https://ziperello.apponic.com/)、[APCHPR](https://cn.elcomsoft.com/archpr.html)）
* 嵌套压缩包
* 压缩包炸弹
* 分卷压缩包合并解压
* 掩码爆破

### 流量分析

流量分析是Ｍisc 中重要的考点，也是 Web 安全分析、工业互联网安全中技能的重要组成部分。当黑客攻入你的计算机并被你发现后，你可能能够通过网络设备等留下的日志，查看过去发生的网络流量等情况，从而分析出黑客的行为。 [Wireshark](https://www.wireshark.org/) 是流量分析中最重要的软件之一，你需要熟练地掌握它的使用。

在 Misc 中，你可能会遇到下面这些流量分析的类别：

* USB 流量分析：键盘流量、鼠标流量等
* WebShell 流量分析
* SQL 注入流量分析
* 邮件流量分析
* 蓝牙流量分析
* TLS 加密流量分析
* 工控流量分析

### 取证

通俗地讲，取证要求你化身电子侦探，找到隐藏在数字存储介质里的犯罪者活动记录，或恢复使用者的使用轨迹，比如解密聊天记录、恢复被加密的文件等等。正如其名，这项技术往往用于查找罪行相关物证或间接物证。

Misc 中的取证往往有以下常见的考点：

* 内存取证（Volatility、AXIOM、R-studio）
* 日志分析
* 注册表分析（WRR、RegRipper）
* 磁盘分析（FTK-Imager）
* 数据库取证（Sqlcipher、PslistEditor）
* 配置文件分析（XShell、MobaXterm 等）

> TIP
>
> 上面所提到的工具并不一定需要全部备齐，它们往往有很多替代品，你也可能会在做题中逐渐遇到它们。有时也需要你自己写 Python 等脚本代码，并不是所有工具都能满足的需求。
>
> 你也并不一定要立即掌握每个工具的使用，但当你接触过一次后，你应当铭记。

## 写在最后

Misc 主要考查非常广泛的知识面以及对一些知识点的深入了解，入门简单，可想要真正学好也十分考验个人综合能力。希望大家对于 Misc 的学习不要只停留在工具的使用，而是真正理解其背后的原理，从工具小子到脚本小子，再慢慢成长为 Misc 大师！


