<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.6.10/vue.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/vue-filter/0.2.5/vue-filter.min.js"></script>


 <script type="text/javascript">
        new Vue({
            mixins: [Vue2Filters.mixin],
            el: "#app",
            data: {
                error: false,
                customerid: customerId,
                customer: [],
                discountcodeTotal : 0
   }
