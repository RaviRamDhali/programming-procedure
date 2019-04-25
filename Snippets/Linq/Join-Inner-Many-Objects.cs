return (
	from c in db.Configuration

	join t in db.ConfigurationTypes on c.TypeId equals t.Id
	join s in db.ConfigurationStatusTypes on c.StatusId equals s.Id

	join de in db.DiagramElement on c.Id equals de.ConfigurationId into grpDiagramElements
	from rsDiagramElements in grpDiagramElements.DefaultIfEmpty() //<--- Filter and Left Join

	where c.CompanyId == CompanyId
	where c.Active
	select new BLL.ViewModels.ConfigurationElement()
	{
		Id = c.Id,
		Guid = c.Guid,
		TypeId = c.TypeId,
		StatusId = c.StatusId,
		Name = c.Name,
		Description = c.Description,
		Vendor = c.Vendor,
		Manufacturer = c.Manufacturer,
		Model = c.Model,
		Active = c.Active,
		TypeTitle = t.Title,
		TypeImage = t.Image,
		StatusTitle = s.Title,
		StatusImage = s.Image,
		DiagramElement = (rsDiagramElements == null ? null : new BLL.ViewModels.DiagramElement
		{
			Id = rsDiagramElements.Id,
			Guid = rsDiagramElements.Guid,
			DiagramId = rsDiagramElements.DiagramId,
			ConfigurationId = rsDiagramElements.ConfigurationId,
			ParentDiagramElementId = rsDiagramElements.ParentDiagramElementId,
			CoorX = rsDiagramElements.CoorX,
			CoorY = rsDiagramElements.CoorY,
			Created = rsDiagramElements.Created,
			Modified = rsDiagramElements.Modified,
			Active = rsDiagramElements.Active
		})
}).ToList();
