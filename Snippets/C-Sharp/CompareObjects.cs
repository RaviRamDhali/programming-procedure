
// https://github.com/wbish/jsondiffpatch.net
// JSON object diffs

var jdp = new JsonDiffPatch();
string output = jdp.Diff(Newtonsoft.Json.JsonConvert.SerializeObject(dbCase), Newtonsoft.Json.JsonConvert.SerializeObject(data));
object outjson = Newtonsoft.Json.JsonConvert.DeserializeObject(output);
