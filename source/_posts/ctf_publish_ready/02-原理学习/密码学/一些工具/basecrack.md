---
title: "basecrack"
date: 2025-09-02 18:02:00
disableNunjucks: true
---
# basecrack

网上安装教程很多，来点真实的；

# 使用步骤：

### 1.

在此文件夹中搜索cmd：
![[Pasted image 20241021215330.png]]

### 2.

#### 1.如果是单base：

直接输入：

```python
python basecrack.py -b 密文
```

#### 2.如果是多重加密：

先把密文粘贴到flag.txt中，右键在终端中打开，然后输入：

```python
python basecrack.py --magic -f flag.txt
```


