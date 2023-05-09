~/llvm-install/bin/clang -S ./PR003_test/example1.c -o ./PR003_test/example1.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example1.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example1.ll
~/llvm-install/bin/opt -S ./PR003_test/example1.s  -mem2reg -o ./PR003_test/example1_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example1.ll -o  ./PR003_test/example1.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example1.bc -o  ./PR003_test/example1.o 
gcc ./PR003_test/example1.o -o ./PR003_test/example1

~/llvm-install/bin/clang -S ./PR003_test/example2.c -o ./PR003_test/example2.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example2.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example2.ll
~/llvm-install/bin/opt -S ./PR003_test/example2.s  -mem2reg -o ./PR003_test/example2_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example2.ll -o  ./PR003_test/example2.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example2.bc -o  ./PR003_test/example2.o 
gcc ./PR003_test/example2.o -o ./PR003_test/example2

~/llvm-install/bin/clang -S ./PR003_test/example3.c -o ./PR003_test/example3.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example3.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example3.ll
~/llvm-install/bin/opt -S ./PR003_test/example3.s  -mem2reg -o ./PR003_test/example3_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example3.ll -o  ./PR003_test/example3.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example3.bc -o  ./PR003_test/example3.o 
gcc ./PR003_test/example3.o -o ./PR003_test/example3

~/llvm-install/bin/clang -S ./PR003_test/example4.c -o ./PR003_test/example4.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example4.s  -mem2reg -OPC_constprop -o ./PR003_test/example4.ll
~/llvm-install/bin/opt -S ./PR003_test/example4.s  -mem2reg -o ./PR003_test/example4_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example4.ll -o  ./PR003_test/example4.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example4.bc -o  ./PR003_test/example4.o 
gcc ./PR003_test/example4.o -o ./PR003_test/example4

~/llvm-install/bin/clang -S ./PR003_test/example5.c -o ./PR003_test/example5.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example5.s  -mem2reg -OPC_jump-threading -o ./PR003_test/example5.ll
~/llvm-install/bin/opt -S ./PR003_test/example5.s  -mem2reg -o ./PR003_test/example5_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example5.ll -o  ./PR003_test/example5.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example5.bc -o  ./PR003_test/example5.o 
gcc ./PR003_test/example5.o -o ./PR003_test/example5

~/llvm-install/bin/clang -S ./PR003_test/example6.c -o ./PR003_test/example6.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example6.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example6.ll
~/llvm-install/bin/opt -S ./PR003_test/example6.s  -mem2reg -o ./PR003_test/example6_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example6.ll -o  ./PR003_test/example6.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example6.bc -o  ./PR003_test/example6.o 
gcc ./PR003_test/example6.o -o ./PR003_test/example6

~/llvm-install/bin/clang -S ./PR003_test/example7.c -o ./PR003_test/example7.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example7.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example7.ll
~/llvm-install/bin/opt -S ./PR003_test/example7.s  -mem2reg -o ./PR003_test/example7_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example7.ll -o  ./PR003_test/example7.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example7.bc -o  ./PR003_test/example7.o 
gcc ./PR003_test/example7.o -o ./PR003_test/example7

~/llvm-install/bin/clang -S ./PR003_test/example8.c -o ./PR003_test/example8.s -emit-llvm
# ~/llvm-install/bin/opt -S ./PR003_test/example8.s  -mem2reg -OPC_constprop -o ./PR003_test/example8.ll
# ~/llvm-install/bin/opt -S ./PR003_test/example8.s  -mem2reg -o ./PR003_test/example8_origin.ll
# ~/llvm-install/bin/llvm-as ./PR003_test/example8.ll -o  ./PR003_test/example8.bc
# ~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example8.bc -o  ./PR003_test/example8.o 
# gcc ./PR003_test/example8.o -o ./PR003_test/example8

~/llvm-install/bin/clang -S ./PR003_test/example9.c -o ./PR003_test/example9.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example9.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example9.ll
~/llvm-install/bin/opt -S ./PR003_test/example9.s  -mem2reg -o ./PR003_test/example9_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example9.ll -o  ./PR003_test/example9.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example9.bc -o  ./PR003_test/example9.o 
gcc ./PR003_test/example9.o -o ./PR003_test/example9

~/llvm-install/bin/clang -S ./PR003_test/example10.c -o ./PR003_test/example10.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example10.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example10.ll
~/llvm-install/bin/opt -S ./PR003_test/example10.s  -mem2reg -o ./PR003_test/example10_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example10.ll -o  ./PR003_test/example10.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example10.bc -o  ./PR003_test/example10.o 
gcc ./PR003_test/example10.o -o ./PR003_test/example10

~/llvm-install/bin/clang -S ./PR003_test/example11.c -o ./PR003_test/example11.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example11.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example11.ll
~/llvm-install/bin/opt -S ./PR003_test/example11.s  -mem2reg -o ./PR003_test/example11_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example11.ll -o  ./PR003_test/example11.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example11.bc -o  ./PR003_test/example11.o 
gcc ./PR003_test/example11.o -o ./PR003_test/example11

~/llvm-install/bin/clang -S ./PR003_test/example12.c -o ./PR003_test/example12.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example12.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example12.ll
~/llvm-install/bin/opt -S ./PR003_test/example12.s  -mem2reg -o ./PR003_test/example12_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example12.ll -o  ./PR003_test/example12.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example12.bc -o  ./PR003_test/example12.o 
gcc ./PR003_test/example12.o -o ./PR003_test/example12

~/llvm-install/bin/clang -S ./PR003_test/example13.c -o ./PR003_test/example13.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example13.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example13.ll
~/llvm-install/bin/opt -S ./PR003_test/example13.s  -mem2reg -o ./PR003_test/example13_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example13.ll -o  ./PR003_test/example13.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example13.bc -o  ./PR003_test/example13.o 
gcc ./PR003_test/example13.o -o ./PR003_test/example13

~/llvm-install/bin/clang -S ./PR003_test/example14.c -o ./PR003_test/example14.s -emit-llvm
~/llvm-install/bin/opt -S ./PR003_test/example14.s  -mem2reg -OPC_early-cse -OPC_jump-threading -OPC_licm  -o ./PR003_test/example14.ll
~/llvm-install/bin/opt -S ./PR003_test/example14.s  -mem2reg -o ./PR003_test/example14_origin.ll
~/llvm-install/bin/llvm-as ./PR003_test/example14.ll -o  ./PR003_test/example14.bc
~/llvm-install/bin/llc -filetype=obj  ./PR003_test/example14.bc -o  ./PR003_test/example14.o 
gcc ./PR003_test/example14.o -o ./PR003_test/example14