var data = (
from o in CoursePackages
where o.StateAbbr == "AK"
group o by new { o.StateAbbr, o.PackageNumber, o.PackageName } into g
select new
{
	g.Key.StateAbbr,
	g.Key.PackageNumber,
	g.Key.PackageName,
}
).ToList().Dump();
