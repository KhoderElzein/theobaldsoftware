using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using ERPConnect; 

namespace ERPCDemoke01
{
    class Program
    {
        static void Main(string[] args)
        {

            using (ERPCDemoke01.SAPContext context = new SAPContext())
            {
                ERPCDemoke01.SAPContext.GENERALDATAStructure gd = new SAPContext.GENERALDATAStructure();
                gd.DESCRIPT2 = "Hello!";

                ERPCDemoke01.SAPContext.GENERALDATAXStructure gdx = new SAPContext.GENERALDATAXStructure();
                gdx.DESCRIPT2 = "X";
                context.BAPI_FIXEDASSET_CHANGE("000030000000", "0005", gd, gdx, "0000");
            }
        }
    }
}
