# 自动化测试

## 依赖
pip install matplotlib

## 环境
`parent_path = os.path.dirname(sys.path[0]) 
if parent_path not in sys.path:
    sys.path.append(parent_path)`

## 已知缺陷
* iops/带宽值小于4的情况下无法生成bar
* 图片路径不能复原（fix 21-0408）
* 没有转换KB/s为MB/s

## 待优化
* 支持中文
* 传参问题，已精简代码
* ~~图表生成~~
* $3支持选择执行步骤



