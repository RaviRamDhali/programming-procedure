 //Get PotentialBlackListTags not not whitelisted
  var tags = (
      from t in db.Tags
      where !(from w in db.TagWhiteLists select w.Name).Contains(t.Name)
      group t by t.Name into c
      where c.Count() > 2
      select new { Name = c.Key, Count = (from x in c select x.Name).Count() }
  ).OrderBy(x => x.Name).ToList();
