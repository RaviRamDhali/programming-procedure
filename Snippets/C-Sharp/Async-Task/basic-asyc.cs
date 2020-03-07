[HttpPost]
  public async Task<ActionResult> FetchReservations()
  {
      var escape = new Services.Vendors.Escape();
      var postData = escape.InitializePostData();
      Escape.RawJson data = await escape.getApi(postData);

      return PartialView(data);
  }
  
  
public async Task<RawJson> getApi(Models.ExternalApplication.Escape.Post.Data postData)
  {

      using (var httpClient = new HttpClient())
      {

          postData.specification.ID = GlobalSettings.Escape.ID.ToStringOrDefault();
          postData.startDate = "2019-01-01";
          postData.endDate = "2019-10-31";

          var postJson = Newtonsoft.Json.JsonConvert.SerializeObject(postData);
          var data = new StringContent(postJson, Encoding.UTF8, "application/json");

          httpClient.DefaultRequestHeaders.Add("x-api-ID",GlobalSettings.ID.ToString());
          httpClient.DefaultRequestHeaders.Add("x-api-endsystem", "Escape");
          httpClient.DefaultRequestHeaders.Add("Authorization", "xxxxxxxxxxxxxxxxxxxxxxxxx");

          string url = "https://api.com/Search";

          var response = await httpClient.PostAsync(url, data).ConfigureAwait(false);
          var jsonString = await response.Content.ReadAsStringAsync();

          // Escape API sends $id which is an internal escape and is not needed
          // to parse $id we use MetadataPropertyHandling and applied [JsonProperty("$id")] and name to metaid in class
          // ---------------------------------------------
          JsonSerializerSettings settings = new JsonSerializerSettings();
          settings.MetadataPropertyHandling = MetadataPropertyHandling.Ignore;

          RawJson rootObject = JsonConvert.DeserializeObject<RawJson>(jsonString, settings);

          return rootObject;
      }

  }
