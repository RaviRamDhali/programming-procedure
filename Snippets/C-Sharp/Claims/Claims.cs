using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Text;

namespace BLL.Service.Authentication
{
    public class Claim
    {
        // USAGE ---- 
        //var identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        //// Get the claims values
        //var name = identity.Claims.Where(c => c.Type == ClaimTypes.Name)
        //    .Select(c => c.Value).SingleOrDefault();

        //var sid = identity.Claims.Where(c => c.Type == ClaimTypes.Sid)
        //    .Select(c => c.Value).SingleOrDefault();

        //var fullname = identity.Claims.Where(c => c.Type == Authentication.Claim.CustomClaimTypes.FullName)
        //    .Select(c => c.Value).SingleOrDefault();

        //var FullName = identity.FindFirst(Authentication.Claim.CustomClaimTypes.FullName).Value.ToStringOrDefault();
        //var UserId = identity.FindFirst(Authentication.Claim.CustomClaimTypes.UserId).Value.ToGuidOrDefault();
        // USAGE ---- 


        public static class CustomClaimTypes
        {
            public const string UserId = "UserId";
            public const string FullName = "FullName";
        }


        public Claim()
        {
        }

        public List<System.Security.Claims.Claim> SetMPClaims(Model.User.ViewModel user)
        {
            var anaClaims = new List<System.Security.Claims.Claim>
            {
                new System.Security.Claims.Claim(ClaimTypes.NameIdentifier, user.UserGuid.ToStringOrDefault()),
                new System.Security.Claims.Claim(ClaimTypes.Name, user.LastName.ToLower().Trim()),
                new System.Security.Claims.Claim(ClaimTypes.Email, user.EMail.ToStringOrDefault().ToLower().Trim()),
                new System.Security.Claims.Claim(CustomClaimTypes.UserId, user.UserGuid.ToString()),
                new System.Security.Claims.Claim(CustomClaimTypes.FullName, user.FullName),
            };

            return anaClaims;
        }
        
    }
}
