<div id="app" class="m-b-20">
  <select id="ddSite" name="ddSite" class="form-control" v-model="selected">
    <option :value="null">-- Select a Site --</option>
    <option v-for="option in sites" v-bind:value="option.SiteId">
      {{ option.SiteName }}
    </option>
  </select>
  <span v-cloak>Selected: {{ selected }}</span>

  <select id="ddSite" name="ddSite" class="form-control">
    <option value="">-- Select a Site --</option>
    @foreach (var m in Model.Sites)
    {
      <option value="@m.Value">@m.Text</option>
    }
  </select>
</div>


<script type="text/javascript">
  new Vue({
      el: '#app',
      data: { selected: null, sites : [], hello:"Its me"},
      mounted(){
          axios.get("/api/sites/" + companyGuid)
          .then(response => {this.sites = response.data})
      }
  })
  
  Vue.config.devtools = true;
  
</script>
