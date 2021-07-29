 public static List<BLL.ViewModel.Common.KeyValuePair> GenerateExpiryYearsCreditCard(int futureYears = 10)
        {
            List<BLL.ViewModel.Common.KeyValuePair> years = new List<BLL.ViewModel.Common.KeyValuePair>();

            int currentYear = DateTime.Now.Year;
            int maxYear = currentYear + futureYears;

            for (int i = currentYear; i <= maxYear; i++)
            {
                years.Add(new BLL.ViewModel.Common.KeyValuePair{key = i.ToStringOrDefault(),value = i.ToStringOrDefault()});
            }

            return years;
        }



        public static List<BLL.ViewModel.Common.KeyValuePair> GenerateMonthList()
        {
            // Create a new Month list
            List<BLL.ViewModel.Common.KeyValuePair> monthsList = new List<BLL.ViewModel.Common.KeyValuePair>();

            //Loop through months and create list
            for (int i = 1; i <= 12; i++)
            {
                // Get month name by the loop value passed in as the month. year or day does not matter..
                string monthname = new DateTime(DateTime.Now.Year, i, 1).ToString("MMMM", CultureInfo.InvariantCulture);
                
                // Add monthname and month value to list
                monthsList.Add(new BLL.ViewModel.Common.KeyValuePair()
                {
                    key = (0 + i).ToStringOrDefault(), 
                    value = char.ToUpper(monthname[0]).ToString() + monthname.Substring(1)
                });
            }
            
            // Return Month List
            return monthsList;
        }
