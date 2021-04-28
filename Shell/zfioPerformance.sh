# 必要参数设置
# 设置报告路径op
path="/home/output/"
date=`date +%y%m%d`.txt
# 测试项目
block=(4k 1M 128k)
ioway=(libaio sync)
rwway=(randwrite randread write read)
orgin=" -ioengine=ioway -bs=block -rw=rwway -name=reportname" 
#生成后的测试项目
mode=()
rpname=()
#文件存放目录
fileList=()
pngList=()

# fileAddress=${path}${op}
# 创建测试目录
# mkdir -p ${fileAddress}


#生成测试项
getTestList(){
for i in ${ioway[*]}
do
    for j in ${block[*]}
    do
        for k in ${rwway[*]}
        do
            #设定参数
            ys=" -ioengine=${i} -bs=${j} -rw=${k}"
            #fio参数组合mode
            mode[${#mode[*]}]=${ys}
            #定义报告名称
            n="${i}-${j}-${k}"
            rpname[${#rpname[*]}]=${n}
        done
    done
done
#echo ${mode[*]}
#echo ${rpname[*]}
}
# 生成报告
createFile(){
# 创建报告文件
for ((i=0;i<=${#ioway[*]}-1;i++))
do
    #设定文件名
    fn=${path}${op}-${ioway[i]}-${date}  
    #设定PNG文件名
    #png=${path}${op}-${ioway[i]}-${date}.png 
    #生成报告存放数组
    fileList[${#fileList[*]}]=${fn}
    #生成图片存放数组
    #pngList[${#pngList[*]}]=${png}
done

for ((i=0;i<${#fileList[*]};i++))
do  
    echo "create ${fileList[${i}]}"
    sleep 1    
    touch ${fileList[${i}]}
done

}
# 测试fio
fioTest(){
count=${#block[*]}*${#rwway[*]}
for ((i=0;i<=${#fileList[*]}-1;i++))
do
    # 修改报告路径
    #echo ${fileList[${i}]}
    sed -i "s!output!${fileList[${i}]}!g" ${runio}
    for ((j=0;j<=${count}-1;j++))
    do
        changeFile="${mode[${j}+${i}*${count}]} -name=${rpname[${j}+${i}*${count}]}"
        echo "now is ${changeFile}"
        sed -i "s/${orgin}/${changeFile}/g" ${runio}
        #cat ${runio}
        ./${runio}
        # 还原fio文件
        sed -i "s/${changeFile}/${orgin}/g" ${runio}
        #cat ${runio}
        
    done
    # 复原报告路径
    sed -i "s!${fileList[${i}]}!output!g" ${runio}
done
}
# 汇总报告输出
allReportCreate(){   
    for ((i=0;i<${#fileList[*]};i++))
    do
        echo "======================================================${ioway[${i}]}======================================================" >> ${path}${op}-all-${date}
        cat ${fileList[${i}]} |grep -B 1 "BW=" >> ${path}${op}-all-${date}
    done
}

#替换
th(){
    for ((i=0;i<${#ioway[*]};i++))
    do
        echo ${rpname[*]}
        # 定义数据来源文件
        rp=${fileList[${i}]}
        echo "from:"${rp}"building png"        
        for ((j=0;j<${#block[*]};j++))
        do
            # 替换标题
            barTitle=${ioway[${i}]}-${block[${j}]}-$1
            echo ${barTitle}
            sed -i "s/test-title/${barTitle}/" bar.py            
            #替换具体参数
            
            for ((k=0;k<${#rwway[*]};k++))
            do
                rname=${rpname[(${i}*${#block[*]}+${j})*${#rwway[*]}+${k}]}
                #echo $2                
                #echo ${rname}
                num=`cat ${rp} |grep -B 1 "BW=" | grep -A 1 ${rname} | sed -n "2,1p" | awk '{print $4}' | cut -d "(" -f2 | cut -d ")" -f1`
                echo ${num:0-4}
                echo "==============="${num:0:0-4}
                #if ${num:0-4} -eq "kB/s";then
                    #num=${num:0:0-4}/1024
                #fi
                
                # 替换x轴标注
                sed -i "s!mmm${k}!${num:0:0-4}!g" bar.py
                # 替换数值
                sed -i "s!label${k}!${rname}!g" bar.py 
            done   
            # 定义PNG
            sed -i "s!barpng!${path}${op}-${barTitle}.png!g" bar.py
            # 执行py文件
            python3 bar.py
            # 复原
            for ((k=0;k<${#rwway[*]};k++))
            do
                rname=${rpname[(${i}*${#block[*]}+${j})*${#rwway[*]}+${k}]}
                num=`cat ${rp} |grep -B 1 "BW=" | grep -A 1 ${rname} | sed -n "2,1p" | awk '{print $4}' | cut -d "(" -f2 | cut -d ")" -f1`
                echo ${num:0-4}
                echo "==============="num=${num:0:0-4}
                #if ${num:0-4} -eq "kB/s";then
                    #num=${num:0:0-4}/1024
                #fi
                # 替换x轴标注
                sed -i "s!${num:0:0-4}!mmm${k}!g" bar.py
                # 替换数值
                sed -i "s!${rname}!label${k}!g" bar.py 
            done            
            sed -i "s/${barTitle}/test-title/" bar.py
            echo "${path}${op}-${barTitle}.png"
            sed -i "s!${path}${op}-${barTitle}.png!barpng!g" bar.py
        done
        
    done

}
# 使用python生成bar图
barBuild(){
    #预置参数预防获取不到值的情况
    num=-1
    # 判断生成类型
    case $1 in 

    bw)
        echo "create bwPNG"
        # 修改y轴
        sed -i "s!miaoshu!MB/s!g" bar.py
        th bw 
        # 复原
        sed -i "s!MB/s!miaoshu!g" bar.py
        ;;
    iops)
        echo "create iopsPNG"
        # 修改y轴
        sed -i "s!miaoshu!IOPS!g" bar.py
        th iops "`cat ${rp} |grep -B 1 "BW=" | grep -A 1 ${rname} | sed -n "2,1p" | awk '{print $2}' | cut -d "=" -f2 | cut -d "," -f1`"
        sed -i "s!IOPS!miaoshu!g" bar.py
        ;;
    *)
        echo "error! no this type"
        exit 0
        ;;
    esac

}




#参数1位类型
case $1 in 

fc)
    echo "fio will run fio-fc.sh"
    runio="fio-fc.sh"
    ;;
iscsi)
    echo "fio will run fio-iscsi.sh"
    runio="fio-iscsi.sh"
    ;;
nfs)
    echo "fio will run fio-nfs.sh"
    runio="fio-nfs.sh"
    ;;
*)
    echo "error! please enter volume-type!(fc/iscsi/nfs)"
    exit 0
    ;;
esac
#参数2为名称
if [ x$2 != x ]
then
    #设置文件存放位置
    op=$2
    echo "file in ${op}"
else
    echo "error! please enter filename!"
    exit 0
fi


getTestList
createFile
fioTest
allReportCreate
barBuild bw
#barBuild iops
#reportCreate


echo "fi"