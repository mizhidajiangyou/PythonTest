const App = {
    data() {
        return {
            totalTableData: [
                {
                    testdate: '20210516',
                    version: '6.1.7',
                    hardware: '24nvme',
                    personnel: 'mzdjy',
                }
            ],
            FCsrc: 'https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg',
            iSCSIsrc: 'https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg'

        }
    },
};
const app = Vue.createApp(App);
app.use(ElementPlus);
app.mount("#app");