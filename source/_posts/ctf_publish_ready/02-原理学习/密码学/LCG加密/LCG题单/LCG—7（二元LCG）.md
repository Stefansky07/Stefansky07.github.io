---
title: "LCG—7（二元LCG）"
date: 2025-09-26 02:40:00
disableNunjucks: true
tags:
  - CTF
  - Crypto
categories:
  - CTF学习笔记
  - LCG题单
source_note: "D:/1400note/1410CS学习笔记/CTF学习笔记.md/原理学习笔记/密码学/LCG加密/LCG题单/LCG—7（二元LCG）.md"
---
# LCG—7（二元LCG）

# 一：题目类型

（二元LCG）

# 二：题目

```python
from Crypto.Util.number import*  
from secret import flag  
assert flag[:5] == b'cazy{'  
assert flag[-1:] == b'}'  
flag = flag[5:-1]  
assert(len(flag) == 24)  
  
class my_LCG:  
def __init__(self, seed1 , seed2):  
self.state = [seed1,seed2]  
self.n = getPrime(64)  
while 1:  
self.a = bytes_to_long(flag[:8])  
self.b = bytes_to_long(flag[8:16])  
self.c = bytes_to_long(flag[16:])  
if self.a < self.n and self.b < self.n and self.c < self.n:  
break  
  
def next(self):  
new = (self.a * self.state[-1] + self.b * self.state[-2] + self.c) % self.n  
self.state.append( new )  
return new  
  
def main():  
lcg = my_LCG(getRandomInteger(64),getRandomInteger(64))  
print("data = " + str([lcg.next() for _ in range(5)]))  
print("n = " + str(lcg.n))  
  
if __name__ == "__main__":  
main()  
  
# data = [2626199569775466793, 8922951687182166500, 454458498974504742, 7289424376539417914, 8673638837300855396]  
# n = 10104483468358610819
```

# 三：解题思路

相较于普通LCG，只是多了一组生成器，本质还是一样，推出相关等式求出系数。一道例题：
**[图片缺失: Pasted image 20241016185904.png]**

# 四：解题代码

```python
data = [2626199569775466793, 8922951687182166500, 454458498974504742, 7289424376539417914, 8673638837300855396]  
n = 10104483468358610819  
print(getRandomInteger(64))  
print(len(data))  
tmp = [0]  
for i in range(1,5):  
tmp.append(data[i] - data[i - 1])  
a = (tmp[2] * tmp[3] - tmp[1] * tmp[4]) * invert(tmp[2] * tmp[2] - tmp[1] * tmp[3],n) % n  
b = (tmp[3] - a * tmp[2]) * invert(tmp[1],n) % n  
c = (data[4] - a * data[3] - b * data[2]) % n

```

# 五：感悟



