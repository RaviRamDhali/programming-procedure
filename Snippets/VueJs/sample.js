

<script type="text/javascript">

    let affiliate = '<%=aff%>';
    let companyid = '<%=companyid%>';

   new Vue({
        el: '#app',
        data: {
           users: [],
           user: [],
           originalUser : [],
           postData: [{ "aff": aff, "companyid": companyid }],
       },
       methods: {
           fetchData() {
               var vdata = this;
               axios.post('https://app.example.com/api/customer/GetUsers', vdata.postData[0])
               .then(function (response) {
                       vdata.users = response.data.d;
                       console.log(vdata.users);
                   })
                   .catch(function (error) {
                       console.log(error);
                   });
           },
           applyCss(value) {

               var cssTrue = "fa fa-check fa-lg text-success";
               var cssFalse = "";

               if (value)
                   return cssTrue;

               return cssFalse;
           },
           setUser(user){
                if(user){
                    this.user = user;
                    this.originalUser = JSON.parse(JSON.stringify(this.user));
                }
           },
           resetUser(user) {
               if (user) {                   
                    let userIndex = this.users.findIndex(f => f.User === user.User);
                    this.$set(this.users, userIndex, this.originalUser)                  
               }
           },
           saveUser(user){
                axios.post('https://app.example.com/api/customer/SaveUser', user)
                .then(function (response) {
                    let savedUser = response.data.d;
                    console.log(savedUser);
                })
                .catch(function (error) {
                    console.log(error);
                });
           }
       },
       created() {
           this.fetchData()
       },

        
    })
</script>
