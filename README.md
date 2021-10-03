# Radar Data Processing With Applications Component Library
# 雷达数据处理应用器件库
## 安装器件库
### 1.安装必要的依赖项：CVX工具箱
### 2.将文件夹添加到matlab的检索路径当中
### 3.在运行例程之前，先运行根目录中的setup.m文件
## 编程风格
### 1.命名惯例
#### 变量

变量名应该以小写字母开头，大小写混合。

	velocity, angularAcceleration.

具有大作用域的变量应该有有意义的名称。作用域较小的变量可以有较短的名称。

	小作用域: x, y, z
	大作用域: velocity, acceleration

前缀n应该用于表示对象数量的变量。

	nFiles, nCars, nLines

坚持使用复数的约定。

	point, pointArray

代表单个实体编号的变量可以以No作为后缀。

	tableNo, employeeNo

迭代变量应该以i, j, k等命名或作为前缀。

	iFiles, jColumns

对于嵌套循环，迭代应该是字母顺序和有用的名称

	for iFiles = 1:nFiles
		for jPositions = 1:nPositions
		…
		end
	end

避免否定布尔变量名。

	~~isNotFound~~ instead use isFound

首字母缩写，即使通常是大写，也应该混合或小写。

	使用 html, isUsaSpecific

避免使用关键字或特殊值名称。

	千万别这么做。

  #### 常量

命名的常量都应该是大写的，使用下划线来分隔单词。

  	MAX_ITERATIONS, COLOR_RED

常量可以用公共类型名作为前缀。

  	COLOR_RED, COLOR_GREEN, COLOR_BLUE

结构体

结构名应该大小写混合，并以大写字母开头。

	Car, DumpTruck

不要在字段名中包含结构名。

	Use Segment.length
	Avoid Segment.segmentLength

  #### 函数

函数名称应该说明其功能。

函数名的名称应该写成小写或混合大小写。

	width(), computeTotalWidth()

函数应该有有意义的名称。

	Use computeTotalWidth
	Avoid compwid

具有单一输出的函数可以根据输出命名

	shearStress(), standardError()

没有输出参数或只返回句柄的函数应该根据它们所做的事情来命名。

	plotfft()

为访问对象或属性保留前缀get/set。

	getobj(), setappdata()

将前缀 compute 保留给需要计算内容的方法。

	computeSumOfResiduals(), 	computeSpread()

为查找内容的方法保留前缀 find 。

	findOldestRecord()

保留前缀 initialize 用于实例化一个对象或概念。

	initializeProblemState()

保留前缀 is 用于布尔函数。

	isCrazy, isNuts, isOffHisRocker

对对应操作使用对应的名称。

  get/set, add/remove, create/destroy, start/stop, insert/delete, increment/decrement, old/new, begin/end, first/last, up/down, min/max, next/previous, open/close, show/hide, suspend/resume, etc.

避免无意地隐藏函数名。 使用which -all或exist来检查是否有阴影。

#### 一般的

名字中的缩写应该避免。

	Use computeArrivalTime
	Avoid comparr

考虑让名字更容易读。
所有的名字都应该用英语写。

### 2.文件组织结构

#### M类型文件

**模块化的代码。**
用设计良好的小块来构成整体。
编写易于测试的函数。

**明确交互。**
使用输入和输出，而不是全局变量。
用结构体替换长参数列表。

**分区。**
所有子函数和大多数函数都应该很好地完成一件事。
尽可能使用现有的函数，而不是自定义编码的函数。
将多个m文件中使用的代码块移动到函数中。
当一个函数只被另一个函数调用时，使用子函数。
为每个函数编写测试脚本。

**Input/Output**
制作大型功能的输入输出模块。
格式输出，便于使用。对于人类来说，让它易于阅读。对于机器来说，让它变得可解析。

**声明**
Variables and constants
Variables should not be reused unless required by memory limitations.
Related variables of the same type can be declared in a common statement.  Unrelated variables should not be declared in the same statement.
	persistent x, y, z
Document important variables in comments near the start of the file.
Document constants with end of line comments.
	THRESHOLD = 10; % Max noise level
Global Variables
Minimize use of global variables and constants.
Consider using a function instead of a global
