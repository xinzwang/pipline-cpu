# 流水线CPU

## 测试日志

### 1、数学运算指令

|序号|指令名|测试状态|测试者|测试汇编指令|
|:--:|:--:|:--:|:--:|:--:|
|| add | √ | wxz |  |
|| addi| √ | wzl | |
|| addu | √ | wxz |  |
|| addiu | √ | wzl | |
|| sub | √ | wxz |  |
|| subu | √ | wxz |  |
|| clz | 正在测试 | wxz | |
|| clo | 正在测试 | wxz | |
|| and| √ |wxz | |
|| andi| √ | wzl | |
|| sll | √ | wxz |  |
|| sllv| √ | wxz| |
|| srl | √ | wxz |  |
|| srlv| √ | wxz | |
|| sra | √ | wxz | |
|| srav | 正在测试 | wxz | |
|| or| √ |wxz | |
|| ori  | √ | wxz |  |
|| xor| √ |wxz| |
|| xori| √ | wzl | |
|| nor| √ |wxz| |
|| slt| √ | wxz| |
|| slti| √| wzl | |
|| sltu | √ | wxz |  |

### 2、访存指令

|序号|指令名|测试状态|测试者|测试汇编指令|
|:--:|:--:|:--:|:--:|:--:|
|| lw| √ | wzl | |
|| sw| √ | wzl | |
|| lui| √ | wzl| |
|| movn| √ | wxz| |

### 3、跳转指令

|序号|指令名|测试状态|测试者|测试汇编指令|
|:--:|:--:|:--:|:--:|:--:|
|| j  | √ | wzl |  |
|| beq  | 正在测试 | wzl |  |
