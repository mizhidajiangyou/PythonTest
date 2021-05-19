const App = {
    data() {
        return {
            // 测试信息
            totalTableData: [{testdate: '20210516', version: '6.1.7', hardware: '24nvme', personnel: 'mzdjy',}],
            // 服务端硬件信息
            serverInfo:{disk: 'Intel SSD DC P4610 7.68TB * 24', cpu : 'AMD Ryzen ThreadRipper 3990X @ 2.90GHz',memory: '256GB',QLogic: 'XILINX Kintex7 AV7K325', LSI:'INSPUR SAS3008I', Ethernet:'intel X710'},
            // 服务端版本及架构
            serverVersion:{framework:"ARM64",stage:'Gold1',version:'6.1.5',Component:'20210231'},
            // 测试项
            testItems:["FC卷异步、同步读写测试","ISCSI卷异步、同步读写测试","NFS卷异步、同步读写测试"],
            // 结果图
            testResultPic:['https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg','https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg','https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg'],
            poolType: "服务端A、B控各9块盘创建RAID5",
            volumeType:"A、B控存储池分配4个卷给客户端",
            testTime:"每个测试项10086分钟",
            testWay:"客户端测试异步（libaio）/同步(sync)，4k/128k/1m,顺序/随机,读/写",
            tool:"fio-3.16",
            toolParameter:"fio –filename/director= `盘符`/`挂载路径` -direct=1 -thread -size=100% -numjobs=64 -time_based -runtime=1800 -group_reporting -startdelay=30 -ioengine=libaio/sync -rw=read/write/randwrite/randread -bs=4k/128k/1M -name=report",
            FCsrc: 'https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg',
            iSCSIsrc: 'https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg',
            testttt : [{test:'asdasd'}],
            results:["https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg","https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg"],
            resultsTitle:["FC结果:","ISCSI结果:"]
        }
    },
};
const app = Vue.createApp(App);
app.use(ElementPlus);
app.mount("#app");