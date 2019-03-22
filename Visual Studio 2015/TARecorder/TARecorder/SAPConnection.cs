using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using ERPConnect; 
namespace TARecorder
{
    public class SAPConnection
    {
        public static void Set(ref R3Connection con)
        {            
            con.UserName = "Elzein";
            con.Password = "Erfolg12";
            con.Language = "EN";
            con.Client = "800";
            con.Host = "ec5.theobald-software.com";
            con.SystemNumber = 0;
            //con.Protocol = ClientProtocol.NWRFC;   // Optional: If the NW RFC libraries are used.

        }
    }
}
