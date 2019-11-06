public async Task Main(string[] args)
  {
      using (var client = new HttpClient())
      {
          var postData = InitializePostData();

          var json = Newtonsoft.Json.JsonConvert.SerializeObject(postData);
          var data = new StringContent(json, Encoding.UTF8, "application/json");

          client.DefaultRequestHeaders.Add("x-nesthome-api-key", GlobalSettings.APIKey.ToString());
          client.DefaultRequestHeaders.Add("x-nesthome-api-version", "10");
          client.DefaultRequestHeaders.Add("Authorization", "MyUserName **********pw****************");

          string url = "https://api.com/test";

          var response = await client.PostAsync(url, data);
          string jsonString = response.Content.ReadAsStringAsync().Result;

          Console.WriteLine(response.StatusCode);
      }
  }
