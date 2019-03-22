using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using ERPConnect;
using ERPConnect.Utils; 

namespace TARecorder
{
    class Program
    {
        static void Main(string[] args)
        {
            R3Connection con = new R3Connection();
            try
            {
                
                SAPConnection.Set(ref con);
                //con.UseGui = true;
                con.Open(false);
                //SAPTransaction.executeMM02(con);
                SAPTransaction.executeXD02(con);
                Console.ReadLine();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw ex;
            }
            finally
            {
                con.Close();
            }

        }
    }
}
