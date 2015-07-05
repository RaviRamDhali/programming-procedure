var dProject = (from p in ParseObject.GetQuery("project")
                where p.Get<string>("guid").Equals(guid.ToString())
                where p.Get<string>("objectId").Equals("Xakg6FGePe")
                select p);

IEnumerable<ParseObject> project = await dProject.FindAsync().ConfigureAwait(false); ;

