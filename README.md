# 流水线CPU

## 测试日志

### 1、数学运算指令

|序号|指令名|测试状态|测试者|测试汇编指令|
|:--:|:--:|:--:|:--:|:--:|
|1| add | √ | wxz |  |
|2| addi| √ | wzl | |
|3| addu | √ | wxz |  |
|4| addiu | √ | wzl | |
|5| sub | √ | wxz |  |
|6| subu | √ | wxz |  |
|7| clz | 正在测试 | wxz | |
|8| clo | 正在测试 | wxz | |
|9| and| √ |wxz | |
|10| andi| √ | wzl | |
|11| sll | √ | wxz |  |
|12| sllv| √ | wxz| |
|13| srl | √ | wxz |  |
|14| srlv| √ | wxz | |
|15| sra | √ | wxz | |
|16| srav | 正在测试 | wxz | |
|17| or| √ |wxz | |
|18| ori  | √ | wxz |  |
|19| xor| √ |wxz| |
|20| xori| √ | wzl | |
|21| nor| √ |wxz| |
|22| slt| √ | wxz| |
|23| slti| √| wzl | |
|24| sltu | √ | wxz |  |

### 2、访存指令

|序号|指令名|测试状态|测试者|测试汇编指令|
|:--:|:--:|:--:|:--:|:--:|
|25| lw| √ | wzl | |
|26| sw|√ | wzl | |
|27| lui| √ | wzl| |

### 3、跳转指令

|序号|指令名|测试状态|测试者|测试汇编指令|
|:--:|:--:|:--:|:--:|:--:|
|28| j  | √ | wzl |  |
|29| beq  | √ | wzl |  |
|30| bne  | √ | wzl |  |
|31| blez  | √ | wzl |  |
|32| bgtz  | √ | wzl |  |
|33| bgez  | √ | wzl |  |
