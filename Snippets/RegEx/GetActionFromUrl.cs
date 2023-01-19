private static string GetActionFromUrl(string value)
{
        var str = "/pages/new?page=danny&action=nick&ref=ravi";
        string pattern = @"action=([^&]*)";

        Regex rg = new Regex(pattern, RegexOptions.IgnoreCase);
        Match s = rg.Match(value);

        if (s.IsNull() || s.Groups[1].IsNull())
        return string.Empty;

        string result = s.Groups[1].Value.ToStringOrDefault().ToLower();

        return result;
}
