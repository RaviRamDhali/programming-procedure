const app = Vue.createApp({
    data() {
        return {
            loading: false,
            purchaseOrderData: [],
            gridLoaded: false,
        }
    },
    mounted() {
        var vdata = this;
        vdata.fetchPurchaseOrder();
    },
    methods: {
        fetchPurchaseOrder: function () {
            var vdata = this;
            vdata.loading = true;
            DHALIDesigns.api.getPurchaseOrder().then(function (response) {
                vdata.purchaseOrderData = response.data;
                vdata.loading = false;
                vdata.gridLoaded = true;
            });
        }
    },
    updated: function () {
        var vdata = this;
        if (vdata.gridLoaded) {
            $('#table-purchase-order').DataTable({
                "ordering": true,
                searching: true,
                "bAutoWidth": false,
            });
        }
    }
});
app.mount('#app');
