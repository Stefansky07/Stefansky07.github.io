---
title: RC4加密解密算法
date: '2026-04-22 19:50:15'
categories:
  - 密码学笔记
  - 密码学应用
tags:
  - Crypto
  - 对称加密
  - RC4
---

# RC4加密解密算法

**RC4 是一种对称密码**​**[算法](http://lib.csdn.net/base/datastructure)**​ **，它属于对称密码算法中的序列密码 (streamcipher, 也称为流密码)，它是可变密钥长度，面向字节操作的流密码**。

RC4 是流密码 streamcipher 中的一种，为序列密码。RC4 加密算法是 Ron Rivest 在 1987 年设计出的密钥长度可变的加密算法簇。起初该算法是商业机密，直到 1994 年，它才公诸于众。由于 RC4 具有算法简单，运算速度快，软硬件实现都十分容易等优点，使其在一些协议和标准里得到了广泛应用。

**流密码也属于对称密码，但与分组加密算法不同的是，流密码不对明文数据进行分组，而是用密钥生成与明文一样长短的密码流对明文进行加密，加解密使用相同的密钥**。

RC4 算法特点：

(1)、算法简洁易于软件实现，加密速度快，安全性比较高；

(2)、密钥长度可变，一般用 256 个字节。

        对称密码算法的工作方式有四种：电子密码本 (ECB, electronic codebook) 方式、密码分组链接 (CBC, cipherblock chaining) 方式、密文反馈 (CFB, cipher-feedback) 方式、输出反馈 (OFB, output-feedback) 方式。

         **RC4 算法采用的是输出反馈工作方式，所以可以用一个短的密钥产生一个相对较长的密钥序列**。

         OFB 方式的**最大的优点**是消息如果发生错误 (这里指的是消息的某一位发生了改变，而不是消息的某一位丢失)，错误不会传递到产生的密钥序列上；**缺点是**对插入攻击很敏感，并且对同步的要求比较高。

         RC4 的执行速度相当快，它大约是分块密码算法 DES 的 5 倍，是 3DES 的 15 倍，且比高级加密算法 AES 也快很多。RC4 算法简单，实现容易。RC4 的安全保证主要在于输入密钥的产生途径，只要在这方面不出现漏洞，采用 128bit 的密钥是非常安全的。

         **RC4 算法加密流程**：包括**密钥调度算法 KSA** 和**伪随机子密码生成算法 PRGA** 两大部分 (以密钥长度为 256 个字节为例)。

         密钥调度算法：首先初始化状态矢量 S，矢量 S 中元素的值被按升序从 0 到 255 排列，即 S[0]=00, S[1]=1, …, S[255]=255. 同时建立一个临时矢量 T，如果密钥 K 的长度为 256 字节，则将 K 赋给 T。否则，若密钥长度为 keylen 字节，则将 K 的值赋给 T 的前 keylen 个元素，并循环重复用 K 的值赋给 T 剩下的元素，直到 T 的所有元素都被赋值。

**在介绍 RC4 算法原理之前，先看看算法中的几个关键变量：**

       1、**密钥流**：RC4 算法的关键是根据明文和密钥生成相应的密钥流，密钥流的长度和明文的长度是对应的，也就是说明文的长度是 500 字节，那么密钥流也是 500 字节。当然，加密生成的密文也是 500 字节，因为**密文第 i 字节 = 明文第 i 字节 ^ 密钥流第 i 字节**；

       2、**状态向量 S**：长度为 256，S[0],S[1].....S[255]。每个单元都是一个字节，算法运行的任何时候，S 都包括 0-255 的 8 比特数的排列组合，只不过值的位置发生了变换；

       3、**临时向量 T**：长度也为 256，每个单元也是一个字节。如果密钥的长度是 256 字节，就直接把密钥的值赋给 T，否则，轮转地将密钥的每个字节赋给 T；

       4、**密钥 K**：长度为 1-256 字节，注意密钥的长度 keylen 与明文长度、密钥流的长度没有必然关系，通常密钥的长度趣味 16 字节（128 比特）。

**RC4 的原理分为三步：**

1、初始化 S 和 T

```python
for i=0 to 255 do

   S[i] =i;

   T[i]=K[ imodkeylen ];
```

2、初始排列 S

```python
for i=0 to 255 do

   j= (j+S[i]+T[i])mod256;

   swap(S[i],S[j]);
```

3、产生密钥流

```python
for r=0 to len do  //r 为明文长度，r 字节

   i=(i+1) mod 256;

   j=(j+S[i])mod 256;

   swap(S[i],S[j]);

   t=(S[i]+S[j])mod 256;

   k[r]=S[t];
```

**下面给出 RC4 加密解密的 C++ 实现：**

加密类：

```python
/*
	加密类
*/
class RC4 {
public:
	/*
		构造函数，参数为密钥长度
	*/
	RC4(int kl):keylen(kl) {
		srand((unsigned)time(NULL));
		for(int i=0;i<kl;++i){  //随机生产长度为keylen字节的密钥
			int tmp=rand()%256;
			K.push_back(char(tmp));
		}
	}
	/*
		由明文产生密文
	*/
	void encryption(const string &,const string &,const string &);
 
private:
	unsigned char S[256]; //状态向量，共256字节
	unsigned char T[256]; //临时向量，共256字节
	int keylen;		//密钥长度，keylen个字节，取值范围为1-256
	vector<char> K;	  //可变长度密钥
	vector<char> k;	  //密钥流
 
	/*
		初始化状态向量S和临时向量T，供keyStream方法调用
	*/
	void initial() {
		for(int i=0;i<256;++i){
			S[i]=i;
			T[i]=K[i%keylen];
		}
	}
	/*
		初始排列状态向量S，供keyStream方法调用
	*/
	void rangeS() {
		int j=0;
		for(int i=0;i<256;++i){
			j=(j+S[i]+T[i])%256;
			//cout<<"j="<<j<<endl;
			S[i]=S[i]+S[j];
			S[j]=S[i]-S[j];
			S[i]=S[i]-S[j];
		}
	}
	/*
		生成密钥流
		len:明文为len个字节
	*/
	void keyStream(int len);
 
};
void RC4::keyStream(int len) {
	initial();
	rangeS();
 
	int i=0,j=0,t;
	while(len--){
		i=(i+1)%256;
		j=(j+S[i])%256;
 
		S[i]=S[i]+S[j];
		S[j]=S[i]-S[j];
		S[i]=S[i]-S[j];
 
		t=(S[i]+S[j])%256;
		k.push_back(S[t]);
	}
}
void RC4::encryption(const string &plaintext,const string &ks,const string &ciphertext) {
	ifstream in;
	ofstream out,outks;
 
	in.open(plaintext);
	//获取输入流的长度
	in.seekg(0,ios::end);
	int lenFile=in.tellg();
	in.seekg(0, ios::beg);
 
	//生产密钥流
	keyStream(lenFile);
	outks.open(ks);
	for(int i=0;i<lenFile;++i){
		outks<<(k[i]);
	}
	outks.close();
 
	//明文内容读入bits中
	unsigned char *bits=new unsigned char[lenFile];
	in.read((char *)bits,lenFile);
	in.close();
 
 
	out.open(ciphertext);
	//将明文按字节依次与密钥流异或后输出到密文文件中
	for(int i=0;i<lenFile;++i){
		out<<(unsigned char)(bits[i]^k[i]);
	}
        out.close();
 
	delete []bits;
}
```

解密类：

```python
/*
	解密类
*/
class RC4_decryption{
public:
	/*
		构造函数，参数为密钥流文件和密文文件
	*/
	RC4_decryption(const string ks,const string ct):keystream(ks),ciphertext(ct) {}
	/*
		解密方法，参数为解密文件名
	*/
	void decryption(const string &);
 
private:
	string ciphertext,keystream;
};
void RC4_decryption::decryption(const string &res){
	ifstream inks,incp;
	ofstream out;
 
	inks.open(keystream);
	incp.open(ciphertext);
 
	//计算密文长度
	inks.seekg(0,ios::end);
	const int lenFile=inks.tellg();
	inks.seekg(0, ios::beg);
	//读入密钥流
	unsigned char *bitKey=new unsigned char[lenFile];
	inks.read((char *)bitKey,lenFile);
	inks.close();
	//读入密文
	unsigned char *bitCip=new unsigned char[lenFile];
	incp.read((char *)bitCip,lenFile);
	incp.close();
 
	//解密后结果输出到解密文件
	out.open(res);
	for(int i=0;i<lenFile;++i)
		out<<(unsigned char)(bitKey[i]^bitCip[i]);
 
	out.close();
}
```

程序实现时，需要注意的是，状态向量数组 S 和临时向量数组 T 的类型应设为 unsigned char，而不是 char。因为在一些机器下，将 char 默认做为 signed char 看待，在算法中计算下标 i，j 的时候，会涉及 char 转 int，如果是 signed 的 char，那么将 char 的 8 位拷贝到 int 的低 8 位后，还会根据 char 的符号为，在 int 的高位补 0 或 1。由于密钥是随机产生的，如果遇到密钥的某个字节的高位为 1 的话，那么计算得到的数组下标为负数，就会越界。

程序运行示例

main 函数：

```python
int main(){
	RC4 rc4(16); //密钥长16字节
	rc4.encryption("明文.txt","密钥流.txt","密文.txt");
 
	RC4_decryption decrypt("密钥流.txt","密文.txt");
	decrypt.decryption("解密文件.txt");
 
}
 
```

明文：我爱小兔子！

密文：'柀 L&t 餥 6 洲

密钥流：镈膺嚬 3 屽 u

解密文件：我爱小兔子！
