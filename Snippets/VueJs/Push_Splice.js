directories:[],
directoryEnrollment : [],
directory: [],

directorySearch: function () {
    var vdata = this;
    var filtered = FilterArray(vdata.selectOptions.Directories, vdata.directorySearchTerm);
    vdata.directories = filtered;
},

clickDirectoryEnrollment: function () {
    var vdata = this;
    vdata.directoryEnrollment.push(vdata.directory)
    console.log('vdata.directoryEnrollment', vdata.directoryEnrollment)
},

clickDirectoryEnrollmentRemove : function (index) {
    var vdata = this;
    vdata.directoryEnrollment.splice(index, 1);
}

// Add new object into existing array object
// Here I am added a new object error into product array
Vue.set(item, 'error', response.data);
// Usage
beforeUpdate: function () {
        this.setNewErrorObjectForEachDiscountCode()
},
   
setNewErrorObjectForEachDiscountCode: function () {
            var vdata = this;
            for (i = 0; i < vdata.discountCodes.length; i++) {
                var item = vdata.discountCodes[i];
                Vue.set(item, 'error', null);
            }
        }
// -----------------------------------------------
// -----------------------------------------------

        
<select size="11" class="form-control" v-model="directory"
 v-on:change="clickDirectoryEnrollment()"
 >
     <option v-for="item in directories" v-bind:value="item">
         {{ item.Text }}
     </option>
 </select>



<div v-for="(item, index) in directoryEnrollment">
    <span class="badge badge-primary">{{item.Text}}
        <a class="text-white"
            v-on:click.prevent="clickDirectoryEnrollmentRemove(index)">
            <span>[x]</span>
        </a>
    </span>
</div>
