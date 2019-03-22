using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using ERPConnect.Utils;
namespace TARecorder
{
    public class SAPTransaction
    {
        public static void executeMM02(ERPConnect.R3Connection sapconnection)
        {
            // Please do not forget to import namspace ERPConnect.Utils
            Transaction trans = new Transaction();
            // confirm all enters
            trans.ExecutionMode = TransactionDialogMode.ShowAll;
            

            //Please assign a valid R3Connection object to the Transaction object
            trans.Connection= sapconnection;
            trans.TCode = "MM02";


            //Begin a new Dynpro
            // Set Material Number
            trans.AddStepSetNewDynpro("SAPLMGMM", "0060");
            trans.AddStepSetCursor("RMMG1-MATNR");
            trans.AddStepSetOKCode("=ENTR");            
            trans.AddStepSetField("RMMG1-MATNR", "100-100");

            //Begin a new Dynpro
            // Select Basic Views 1 & 2
            trans.AddStepSetNewDynpro("SAPLMGMM", "0070");
            trans.AddStepSetCursor("MSICHTAUSW-DYTXT(02)");
            trans.AddStepSetOKCode("=ENTR");
            trans.AddStepSetField("MSICHTAUSW-KZSEL(01)", "X");
            trans.AddStepSetField("MSICHTAUSW-KZSEL(02)", "X");

            //Begin a new Dynpro
            trans.AddStepSetNewDynpro("SAPLMGMM", "4004");
            trans.AddStepSetOKCode("=BU");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGMM                                2004TABFRA1");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                1002SUB1");
            trans.AddStepSetField("MAKT-MAKTX", "Casings");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                2001SUB2");
            trans.AddStepSetField("MARA-MEINS", "PC");
            trans.AddStepSetField("MARA-MATKL", "001");
            trans.AddStepSetField("MARA-BISMT", "4711");
            trans.AddStepSetField("MARA-SPART", "00");
            trans.AddStepSetField("MARA-PRDHA", "001000010500000115");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                2561SUB3");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                2007SUB4");
            trans.AddStepSetCursor("MARA-NTGEW");
            trans.AddStepSetField("MARA-BRGEW", "3");
            trans.AddStepSetField("MARA-GEWEI", "KG");
            trans.AddStepSetField("MARA-NTGEW", "3");
            trans.AddStepSetField("MARA-EAN11", "3165140652735");
            trans.AddStepSetField("MARA-NUMTP", "HE");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                2005SUB5");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                2011SUB6");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                2033SUB7");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                0001SUB8");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                0001SUB9");
            trans.AddStepSetField("BDC_SUBSCR", "SAPLMGD1                                0001SUB10");

            trans.Execute();


        }

        public static void executeXD02(ERPConnect.R3Connection sapconnection)
        {

            // Please do not forget to import namspace ERPConnect.Utils
            Transaction trans = new Transaction();

            //Please assign a valid R3Connection object to the Transaction object
            trans.ExecutionMode = TransactionDialogMode.ShowAll;
            trans.Connection=sapconnection;
            trans.TCode = "XD02";


            //Begin a new Dynpro
            trans.AddStepSetNewDynpro("SAPMF02D", "0101");
            trans.AddStepSetCursor("RF02D-KUNNR");
            trans.AddStepSetOKCode("=MALL");
            trans.AddStepSetField("RF02D-KUNNR", "1000");

            //Begin a new Dynpro
            trans.AddStepSetNewDynpro("SAPMF02D", "0101");
            trans.AddStepSetCursor("RF02D-KUNNR");
            trans.AddStepSetOKCode("/00");
            trans.AddStepSetField("RF02D-KUNNR", "1000");
            trans.AddStepSetField("RF02D-D0110", "X");
            trans.AddStepSetField("RF02D-D0120", "X");
            trans.AddStepSetField("RF02D-D0125", "X");
            trans.AddStepSetField("RF02D-D0130", "X");
            trans.AddStepSetField("RF02D-D0340", "X");
            trans.AddStepSetField("RF02D-D0370", "X");
            trans.AddStepSetField("RF02D-D0360", "X");

            //Begin a new Dynpro
            trans.AddStepSetNewDynpro("SAPMF02D", "0110");
            trans.AddStepSetCursor("KNA1-STRAS");
            trans.AddStepSetOKCode("=UPDA");
            trans.AddStepSetField("KNA1-ANRED", "Firma");
            trans.AddStepSetField("KNA1-NAME1", "Becker Berlin AG");
            trans.AddStepSetField("KNA1-SORTL", "BECKER BER");
            trans.AddStepSetField("KNA1-STRAS", "Stuttgarter Str. 33");
            trans.AddStepSetField("KNA1-ORT01", "Berlin");
            trans.AddStepSetField("KNA1-PSTLZ", "13467");
            trans.AddStepSetField("KNA1-ORT02", "Hermsdorf");
            trans.AddStepSetField("KNA1-LAND1", "DE");
            trans.AddStepSetField("KNA1-REGIO", "11");
            trans.AddStepSetField("KNA1-SPRAS", "DE");
            trans.AddStepSetField("KNA1-TELF1", "030-8853-0");
            trans.AddStepSetField("KNA1-TELFX", "030-8853-999");
            trans.AddStepSetField("KNA1-KNURL", "www.sap.com");

            trans.Execute();



        }
    }
}
