using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using ERPConnect;

namespace ECS_SSO
{
    class Program
    {
        static void Main(string[] args)
        {
            using (R3Connection con = new R3Connection())
            {
                con.Host = "saperp.theobald.local";
                con.SystemNumber = 0;
                con.Client = "800";
                con.Language = "DE";
                con.SNCSettings.Enabled = true;
                con.SNCSettings.PartnerName = "p:SAPServiceERP@THEOBALD.LOCAL";               
                con.SNCSettings.Mechanism = SNCMechanism.Kerberos5;
                con.SNCSettings.QualityOfProtection = SNCQualityOfProtection.Maximum;
                con.Open();
                // do something with con
                Console.WriteLine("SSO Connection Succesful!"); 
            }

        }
    }
}
