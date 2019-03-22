using System;
using System.Collections.Generic;
using System.Text;
using ERPConnect;
using ERPConnect.Utils;


namespace BOARDBWUpload
{
    class Program
    {
        static void Main(string[] args)
        {
            string mypath = AppDomain.CurrentDomain.BaseDirectory;
            string myfile = mypath + "DSOInput.csv";
            string res;
            try
            {
                ERPConnect.LIC.SetLic("17YZYZ5VVZ");

                string[] myLines = System.IO.File.ReadAllLines(myfile);
                string dsoname = "ZKEDSO01"; // ZBOARD01

                R3Connection con = new R3Connection("bw2.theobald-software.com",0, "Demouser1", "Board2016", "DE", "800");

              

                con.Open();

                RFCFunction delfunc = con.CreateFunction("RSDRI_ODSO_DELETE_RFC");
                delfunc.Exports["I_DELETE_ALL"].ParamValue = "X";
                delfunc.Exports["I_ODSOBJECT"].ParamValue = dsoname;
                delfunc.Execute();

                RFCFunction insfunc = con.CreateFunction("RSDRI_ODSO_INSERT_RFC");
                insfunc.Exports["I_ODSOBJECT"].ParamValue = dsoname;

                foreach (string myline in myLines)
                {
                    if (!myline.StartsWith("Item"))
                    {
                        string[] vals = myline.Split(",".ToCharArray());

                        if (vals.Length >= 4)
                        {
                          
                            string st = string.Empty;
                            st += vals[1].PadRight(10); // Customer 10 
                            st += vals[2].PadRight(18); // Material 18  
                            st += vals[3].PadRight(8); // Date 8 
                    

                            RFCStructure neworw = insfunc.Tables["I_T_DATA"].Rows.Add();
                            neworw["DATA"] = st;

                    
                        }
                    }
                }
               insfunc.Execute();

                int num = (int) insfunc.Imports["E_NUMROWS"].ParamValue;
                res = num + " rows inserted into DSO " + dsoname;
            }
            catch (Exception e1)
            {
                System.IO.File.WriteAllText(mypath + "UploadLog.txt", e1.ToString());
                return;
            }
            System.IO.File.WriteAllText(mypath + "UploadLog.txt", res);
        }
    }
}

/*

        //st += vals[6].Substring(vals[6].Length - 4, 4).PadRight(4); // Geschäftsjahr XX
                            //st += "K1".PadRight(2); // Geschäftsjahresvariante
                            //st += vals[1].PadRight(6); // Performance Unit XX
                            //st += vals[3].PadRight(10); // Magnt. Entity XX
                            //st += vals[4].PadRight(10); // Partner Mgtn. Entity XX
                            //st += vals[0].Substring(3).PadRight(10); // Position XX
                            //st += vals[2].PadRight(2); // Positionsplan XX
                            //st += vals[5].PadRight(2); // Kontierungsebene XX
                            //st += " ".PadRight(2); // Recordmode
                            //st += vals[7].PadRight(15); // Cum Val XX

               RFCTableColumnCollection columns = new RFCTableColumnCollection();
                columns.Add(new RFCTableColumn("/BIC/ZTHCUST01", 10, 0, RFCTYPE.CHAR));
                columns.Add(new RFCTableColumn("/BIC/ZTHMAT01", 18, 0, RFCTYPE.CHAR));
                columns.Add(new RFCTableColumn("/BIC/ZTHDATE01", 8, 0, RFCTYPE.DATE));
                columns.Add(new RFCTableColumn("RECORDMODE", 1, 0, RFCTYPE.CHAR));
                columns.Add(new RFCTableColumn("/BIC/ZTHQUAN01", 10, 0, RFCTYPE.INT));
                RFCTable rfctab = new RFCTable("DSO", columns); 

                                RFCStructure item = rfctab.AddRow();
                            // /BIC/ZTHCUST01
                            item["/BIC/ZTHCUST01"] = vals[1];
                            // /BIC/ZTHMAT01 
                            item["/BIC/ZTHMAT01"] = vals[2];
                            // /BIC/ZTHDATE01 
                            item["/BIC/ZTHDATE01"] = vals[3];
                            // /BIC/ZTHQUAN01 
                            item["/BIC/ZTHQUAN01"] = vals[4];
                            // RECORDMODE 
                            item["RECORDMODE"] = "0";

  
*/
