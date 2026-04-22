---
title: "安装ciphey的一些碎碎念"
date: 2025-08-30 16:48:00
categories:
  - CTF学习笔记
  - 脚本
tags:
  - Script
  - Crypto
  - ciphey
  - 工具安装
disableNunjucks: true
---
# 安装ciphey的一些碎碎念

#### 一：前言：

在做题的时候，看见有师傅推荐Ciphey，Ciphey是一个功能强大的自动化解密工具，它具备出色的智能分析能力，能够迅速识别并解密各种加密或编码的文本。但是在我电脑上存在着原来的python3.1.2。Ciphey令人恶心的地方在于它是逐位检测python版本的，所以3.1.2会被认为低于3.8版本，因此会报错。所以我想到了用Anaconda进行安装。下面我分享一下我的安装过程。

#### 二：安装Anaconda

Anaconda 是专门为了方便使用 Python 进行[数据科学](https://so.csdn.net/so/search?q=数据科学&spm=1001.2101.3001.7020)研究而建立的一组软件包，涵盖了数据科学领域常见的 Python 库，并且自带了专门用来解决软件环境依赖问题的 conda 包管理系统。
首先我们来安装Anaconda：

###### 1.官网太慢，这里我推荐用镜像源来下载：

清华大学镜像源：[[Index of /anaconda/archive/ | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/)]()
![[Pasted image 20240926212224.png]]
我们直接拉到最下面，下载最新版：
![[Pasted image 20240926212334.png]]
以我windows为例，我下载的是这个，其他操作系统下载对应的即可。

###### 2.安装Anaconda

![[Pasted image 20240926213401.png]]
**直接点Next**
![[Pasted image 20240926213428.png]]
点I Agree
![[Pasted image 20240926213456.png]]
**这里要点All Users，然后点next**
![[Pasted image 20240926213551.png]]
**这里选自己要安装的位置，同时记一下位置，一会要编辑环境变量会用到。改完之后点next。** 
![[Pasted image 20240926213724.png]]
**这里选第二个：不添加环境变量，然后点Install，因为我已经安装了，所以就不演示下面了。** 
![[Pasted image 20240926213833.png]]
**到最后会有这个提示，我们不要选。到这里我们就安完Anaconda了。**

###### 3.编辑环境变量

相信能找到这的师傅应该都会编辑环境变量，在此不在赘述。
我们要在path里添加四个环境变量，如图所示，其中路径应该是自己的Anaconda安装路径。

```
F:\ANACONDA  
F:\ANACONDA\Scripts  
F:\ANACONDA\Library\mingw-w64\bin  
F:\ANACONDA\Library\bin
```

这是我的安装路径，师傅们注意替换。
![[Pasted image 20240926214413.png]]
如图。
接下来我们进行下一步，在Anaconda中操作。

### 三：Anaconda安装python环境

1.首先我们Win+R
![[Pasted image 20240926214902.png]]
2.输入cmd进入命令行页面
![[Pasted image 20240926214932.png]]
3.我们输入：

```
conda --version  
conda info  
python
```

检查是否有问题
如果如图，则无问题：
![[Pasted image 20240926215105.png]]
4.我们来安装python环境，==注意：只可以安装3.8环境！==不知道为什么，我安装其他环境会出现莫名报错，所以保险起见，我们还是安装3.8环境。输入如下代码，conda会执行安装命令：

```
conda create --name tensorflow python=3.8.8
```

5.查看环境是否安装成功：

```
conda info --envs
```

如下即为成功：
![[Pasted image 20240926215427.png]]
6.激活环境，以使用该环境（安装的包将会在此环境下）

```
conda activate tensorflow
```

![[Pasted image 20240926215623.png]]
7.输入：

```
conda list
```

，我们可以看到已安装的包：
![[Pasted image 20240926215824.png]]
接下来我们输入：

```
 pip install ciphey  -i https://pypi.mirrors.ustc.edu.cn/simple/

```

安装Ciphey。
8.这样便安装成功了：
![[%(R8_MV3(HS{%5Q67[X%}WQ.png]]

### 四：报错处理

1.在安装完Ciphey完不能直接使用，我们还需要改一点东西。
2.首先我们打开

```
F:\ANACONDA\envs\tensorflow\Lib\site-packages\pywhat
```

这里Anaconda地址是各位师傅自己安装的位置，我们打开这个文件。
3.找到：
![[Pasted image 20240926220455.png]]
打开它
4.找到：

```python
def __init__(self):
        path = "Data/regex.json"
        fullpath = os.path.join(os.path.dirname(os.path.abspath(__file__)), path)
        with open(fullpath, "r") as myfile:
            self.regexes = json.load(myfile)
```

把

```python
with open(fullpath, "r") as myfile
```

改为：

```python
with open(fullpath, "rb") as myfile
```

5.这样就欧克了，我们来测试一下:
输入：

```
ciphey -t 4O595954494Q32515046324757595N534R52415653334357474R4N575955544R4O5N4Q46434S4O59474253464Q5N444R4Q51334557524O5N4S424944473542554O595N44534O324R49565746515532464O49345649564O464R4R494543504N35
```

欧克了！
![[Pasted image 20240926220905.png]]

### 五：结尾

这样安装就完成了，感谢各位师傅的观看！
本文参照了如下师傅的一些文章：
1.[安装conda搭建python环境（保姆级教程）_conda创建python虚拟环境-CSDN博客](https://blog.csdn.net/Q_fairy/article/details/129158178)
2.[【CTF-Crypto工具】Ciphey安装教程（Window+Kali存在多版本python）-CSDN博客](https://blog.csdn.net/Red_carp/article/details/138624331?ops_request_misc=%7B%22request%5Fid%22%3A%22A0FC92ED-69C6-402C-9211-4AB86DDDB776%22%2C%22scm%22%3A%2220140713.130102334..%22%7D&request_id=A0FC92ED-69C6-402C-9211-4AB86DDDB776&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-138624331-null-null.142^v100^control&utm_term=ciphey&spm=1018.2226.3001.4187)


