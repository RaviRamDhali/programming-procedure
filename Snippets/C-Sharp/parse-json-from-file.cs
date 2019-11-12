public void ParseJson()
{
    string json = string.Empty;

    using (StreamReader r = new StreamReader(@"c:\temp\text.json"))
    {
        json = r.ReadToEnd();

        JsonSerializerSettings settings = new JsonSerializerSettings();
        settings.MetadataPropertyHandling = MetadataPropertyHandling.Ignore;

        RawJson rootObject = JsonConvert.DeserializeObject<RawJson>(json, settings);

    }
}
