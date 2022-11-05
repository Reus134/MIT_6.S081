# MIT_6.S081
#这个是lecture1的一些修改
注意修改主要是两个 一个是加了一个copy.c 
然后是这个下面加了一个_copy
UPROGS=\
	$U/_cat\
	$U/_echo\
	$U/_forktest\
	$U/_grep\
	$U/_init\
	$U/_kill\
	$U/_ln\
	$U/_ls\
	$U/_mkdir\
	$U/_rm\
	$U/_sh\
	$U/_stressfs\
	$U/_usertests\
	$U/_grind\
	$U/_wc\
	$U/_zombie\
	$U/_copy\

不止添加了copy还有forkexe 和open