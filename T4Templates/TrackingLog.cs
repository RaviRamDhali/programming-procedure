namespace BLL.Commands
{
    using System;
    using System.ComponentModel;
    using System.Web;

    using BLL.Tools;

    using DAL;

    public class TrackingLog
    {

        // Tracking States
        [Serializable]
        public enum TrackingState
        {
            [Description("Created")]
            Created = 1,
            [Description("Updated")]
            Updated = 2,
            [Description("Deleted")]
            Deleted = 3,
            [Description("AuthSuccess")]
            AuthSuccess = 4,
            [Description("AuthAttempt")]
            AuthAttempt = 5,
            [Description("SessionState")]
            SessionState = 6,
            [Description("MemberEmail")]
            MemberEmail = 7,
            [Description("WarningMSG")]
            Warning = 8,
            [Description("Tracking")]
            Tracking = 8,
            [Description("AuthLogout")]
            AuthLogout = 11,

        }

        public static void CreateLog(TrackingLog.TrackingState trackState, string memo, string recordTable, int? recordId = 0,
            int? affectedMemId = 0)
        {
            var view = new ModelViews.TrackingLog.Extend();

            view.TrackingState = Convert.ToInt16(trackState);
            view.Memo = memo;
            view.RecordTable = recordTable;

            int rID = int.TryParse(recordId.ToString(), out rID) ? rID : 0;
            view.RecordId = rID;

            int affectedId = int.TryParse(affectedMemId.ToString(), out affectedId) ? affectedId : 0;

            var account = Queries.Account.GetByGuid(WebSessions.AccountId);
            view.AuthUserId = (account != null) ? account.Id : 0;
            view.ClientId = (account != null) ? account.ClientID : 0;

            var track = Create(view);

        }

        private static ModelViews.TrackingLog.Extend Create(ModelViews.TrackingLog.Extend view)
        {
            var data = new DAL.trackingLog();
            try
            {
                using (var ctx = new TraditionEntities())
                {
                    if (view.Id == 0)
                    {

                        data.clientId = view.ClientId;
                        data.authUserId = view.AuthUserId;
                        data.recordId = view.RecordId;
                        data.recordTable = view.RecordTable;
                        data.memo = view.Memo;
                        data.trackingState = view.TrackingState;

                        data.created = DateTime.Now;
                        data.ipAddress = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];

                        ctx.AddTotrackingLogs(data);
                        ctx.SaveChanges();

                    }
                }
            }
            catch (Exception ex)
            {
                data = new DAL.trackingLog();
            }
            return Mappers.TrackingLog.Basic(data);
        }
    }
}
