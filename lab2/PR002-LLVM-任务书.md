# 编译原理研讨课实验PR002-LLVM任务书

## C语言添加overflow check支持

### 实验内容：

为标记了overflowCheck制导的函数添加静态检查和动态检查：

静态检查

```c
#pragma overflowCheck
int test(){
	int A[1000];
	int a = A[1000];
	return 0;
}
```

的代码，编译时报错：

```c
array index 1000 is past the end of the array (which contains 1000 elements)
```

动态检查

```c
#pragma overflowCheck
int test(int n){
	int A[1000];
	int a = A[n];
	return 0;
}
```

的代码，等价于：

```c
#pragma overflowCheck
int test(int n){
	int A[1000];
    assert(n <= 1000 && “overflow check failed!\n”);
	int a = A[n];
	return 0;
}
```



**要求如下：**

1. `支持静态检查`
2. `支持动态检查`
3. `数组限制为静态大小的一维数组`
4. `编译器可以直接报错或编译符合规范的源代码文件生成二进制文件并正确执行`



### 验收标准：

1. 实验报告提交到课程网站
   1. 课程网站有模板供参考。
2. 实验源代码提交至每组对应的Gitlab账号的LLVM工程当中(master分支)，我们将重新编译各位同学的代码，并根据相应的case进行检查。
   1. `http://124.16.71.65/llvm1/llvm.git`，其中`llvm1`是每组的用户名，每组根据自己的组号修改。当在课程提供的服务器上操作时，初始密码为`llvm1!llvm1!`，每组根据自己组名调整。
3. 实验源代码提交至每组对应的Gitlab账号的LLVM工程当中(master分支)，我们将重新编译各位同学的代码，并根据相应的case进行检查。
4. PR002会提供一些case，每组可以增加不同情况的case。