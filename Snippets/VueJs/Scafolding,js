// HTNL Markup
// <td><i v-bind:class="applyCss(item.Active)"></i></td>

<script type="text/javascript">
   new Vue({
        el: '#app',
        data: {
           users: [],
           postData: [{"affiliate":"","companyid":""}]
       },
       mounted: function () {

       },
       methods: {
           fetchData() {
               var vdata = this;
               axios.post('https://app.xxxxxxxx.com/api/customer/GetUsers', vdata.postData[0])
               .then(function (response) {
                       vdata.users = response.data.d;
                       console.log(vdata.users);
                   })
                   .catch(function (error) {
                       console.log(error);
                   });
           },
           applyCss(cameron) {

               var cssTrue = "fa fa-check fa-lg text-success";
               var cssFalse = "";

               if (cameron)
                   return cssTrue;

               return cssFalse;
           }
       },
       created() {
           this.fetchData()
       },

        
    })
</script>
