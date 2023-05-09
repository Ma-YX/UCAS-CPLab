# a编译原理研讨课实验PR003-LLVM任务书

## C语言添加overflow check支持优化

### 实验内容：

为标记了overflowCheck制导的函数添加的检查进行编译优化：

源码

```c
#pragma overflowCheck
int test(){
	int A[1000];
    int n = 1000;
	int a = A[n];
	return 0;
}
```

按照PR002-LLVM的任务书，已经为其添加了动态检查

```c
#pragma overflowCheck
int test(int n){
	int A[1000];
    int n = 1000;
    assert(n <= 1000 && “overflow check failed!\n”);
	int a = A[n];
	return 0;
}
```

但是，由于常量传播，我们可以知道n的值为1000，因此可以通过编译时优化在编译时报出这个访问越界的错，而不需要实际插入IR。

**要求如下：**

1. `对overflow Check添加的IR进行优化`
2. `要求完成的基础优化为常量传播，死代码删除，循环不变量外提，公共子表达式删除`
3. `其他的优化不限`
4. `编译器可以直接报错或编译符合规范的源代码文件生成二进制文件并正确执行`



### 验收标准：

1. 实验报告提交到课程网站
   1. 课程网站有模板供参考。
2. 实验源代码提交至每组对应的Gitlab账号的LLVM工程当中(master分支)，我们将重新编译各位同学的代码，并根据相应的case进行检查。
   1. `http://124.16.71.65/llvm1/llvm.git`，其中`llvm1`是每组的用户名，每组根据自己的组号修改。当在课程提供的服务器上操作时，初始密码为`llvm1!llvm1!`，每组根据自己组名调整。
3. 实验源代码提交至每组对应的Gitlab账号的LLVM工程当中(master分支)，我们将重新编译各位同学的代码，并根据相应的case进行检查。
4. PR003会提供一些case，每组可以增加不同情况的case。