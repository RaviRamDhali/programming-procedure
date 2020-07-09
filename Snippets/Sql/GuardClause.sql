	-- SET @CompanyID = 'RAM'
	
	-- SET @CompanyID = ' RAM'

	-- SET @CompanyID = (LTRIM(RTRIM(@CompanyID)))
	-- SET @CompanyID = ISNULL(@CompanyID, 'RAM')

	SET @StateAbbr = '     '
	SET @StateAbbr = (LTRIM(RTRIM(@StateAbbr)))
	SET @StateAbbr = nullif(@StateAbbr,'') -- makes null if empty string

	-- New Clause
		-- AND (@CompanyID IS NULL OR C.AffiliateName = @CompanyID)
		
