---
title: "Is this only base"
date: 2025-02-11 15:25:00
disableNunjucks: true
---
# Is this only base

# 题目

SWZxWl=F=DQef0hlEiSUIVh9ESCcMFS9NF2NXFzM  
今年是本世纪的第23年呢

# 分析

需要动动脑子，看到两个等号可以判断是base64加密，题目又提示23，可以判断是栅栏加密：

![image](assets/image-20250926111113-18gm3h5.png)

然后base64解密：

![image](assets/image-20250926111150-hmnj4vl.png)

解出来是乱码，试试凯撒：

![image](assets/image-20250926111215-e0mz1m3.png)

# Flag

NSSCTF{LeT_Us_H4V3_fU0!!!!!}

# 参考


