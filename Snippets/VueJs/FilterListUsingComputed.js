 computed: {
     filteredConfigurations() {
         console.log('this.selectedType', this.selectedType)
         if (this.selectedType) {
             return this.configurations.filter((item) => {
                 return item.typeGuid == this.selectedType;
             })
         } else {
             return this.configurations;
         }
     }
 }
 
 Usage:
 <template v-for="item in filteredConfigurations">
