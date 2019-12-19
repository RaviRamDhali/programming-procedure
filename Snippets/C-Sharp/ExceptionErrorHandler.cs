public class ExceptionError
	{
		public static void Handler(Exception exception, string userdetails)
        {
            string innerException = exception.Message;

            if (exception.InnerException.IsNotNull())
            {
                innerException = exception.InnerException.Message;

                if (exception.InnerException.StackTrace.IsNotNull())
                    innerException = innerException + "..... StackTrace:" + exception.InnerException.StackTrace;
            }
            
            EmailServices.SendQuickSysAdminEmail("Exception error", "User Details:" + userdetails + " Message: " + innerException);
		}
	}
