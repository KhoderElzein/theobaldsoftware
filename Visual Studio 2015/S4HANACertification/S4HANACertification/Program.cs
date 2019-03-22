using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using ERPConnect;
using ERPConnect.Idocs;
using ERPConnect.Queries;
using ERPConnect.BW; 


namespace S4HANACertification
{
    class Program
    {
        static void Main(string[] args)
        {

            // Initialisation
            ERPConnect.LIC.SetLic("VYY2ZZ81ZZ");            
            // i - 9156ae16
            //R3Connection con = new R3Connection("52.7.193.1", 00, "BPINST", "Welcome1", "en", "100");

            // ERP, Client 100
            R3Connection con = new R3Connection("vhcals4hci.dummy.nodomain", 00, "Babi", "Welcome100", "en", "100");            
            con.Protocol = ClientProtocol.NWRFC;

            // BW, Client 200
            R3Connection bwcon = new R3Connection("vhcals4hci.dummy.nodomain", 00, "BPINST", "Welcome1", "en", "200");
            //R3Connection bwcon = new R3Connection("vhcals4hci.dummy.nodomain", 00, "Babi", "Welcome2", "en", "200");
            bwcon.Protocol = ClientProtocol.NWRFC;

            // RFC 
            //RFCUserCreate(con, "BTEST06");

            // BAPI 
            //BapiGetFlightList(con); 

            // Query CONNECTIONS_02 ALL
            //ExecuteSAPQuery(con);

            // Send Idoc (synchron)

            // async = true
            //SendIDoc(con, "TESTMAT13",true); 

            // async = false 
            //SendIDoc(con, "TESTMAT14", false);            

            //Start RFC Server to Add 
            //StartRFCServer();

            // Receive IDoc
            // TA BD10 in SAP:
            // Material: TESTMAT, Message Type: MATMAS, LogicalSystem: ERPTEST 
            // /nrz11 gw/acl_mode = 1 -> set to 0 
            //StartIDocServer();

            // BW Cube (MDX)
            // $0D_NW_C01
            GetBWCube(bwcon, "$0D_NW_C01");
        }

        private static void GetBWCube(R3Connection con,string name)
        {
            using (con)
            {               
                con.Open(false);
                //0,0D_NW_CHANN,Distribution Channel, C,255,0
                //1,0D_NW_CNTRY,Country,C,255,0
                //2,0D_NW_CODE,Company code, C,255,0
                //3,0D_NW_DIV,Division,C,255,0
                //4,0D_NW_PAYER,Payer,C,255,0
                //5,0D_NW_PLANT,Plant,C,255,0
                //6,0D_NW_PROD,Product,C,255,0
                //7,0D_NW_REGIO,Region,C,255,0
                //8,0D_NW_SGRP,Sales Group, C,255,0
                //9,0D_NW_SHIP,Ship - to Party,C,255,0
                //10, 0D_NW_SOLD,Sold - to Party,C,255,0
                //11, 0D_NW_SORG,Sales Organization, C,255,0
                //12, 0CALYEAR,Calendar Year, C,255,0
                //13, 0MEASURES0000000000000009_0D9NW9NETV000000000000010,Net Value stat curr, P,16,0
                //14, 0MEASURES0000000000000009_0D9NW9OORV000000000000010,Open order stat curr, P,16,0

                BWCube query = con.CreateBWCube(name);
                query.Dimensions["0D_NW_CHANN"].SelectForFlatMDX = true;
                query.Dimensions["0D_NW_CNTRY"].SelectForFlatMDX = true;
                query.Dimensions["0D_NW_CODE"].SelectForFlatMDX = true;
                query.Dimensions["0D_NW_DIV"].SelectForFlatMDX = true;
                query.Dimensions["0D_NW_PAYER"].SelectForFlatMDX = true;
                query.Dimensions["0D_NW_PLANT"].SelectForFlatMDX = true;

                query.Measures[0].SelectForFlatMDX = true;
                query.Measures[1].SelectForFlatMDX = true;
                query.Measures[2].SelectForFlatMDX = true;
                query.Measures[3].SelectForFlatMDX = true;


                //query.Variables["MAT01"].SingleRange.LowValue = this.txtMatNr.Text;

                DataTable table = query.Execute();

                Console.Read();
            }
        }

        private static void ExecuteSAPQuery(R3Connection con)
        {

            using (con)
            {
               con.Open(false);

                // Create Query object Query q;
                Query q; 
                try
                {
                    q = con.CreateQuery(WorkSpace.GlobalArea,"/SAPQUERY/QD", "CONNECTIONS_02");
                    //q.Variant = "ALL";
                    q.MaxRows = 1000;
                    
                }
                catch (Exception e1)
                {
                    Console.WriteLine(e1.ToString());
                    return;
                }

                // Add a criteria (in this case the material number)
                //q.SelectionParameters["SP$00017"].Ranges.Add(Sign.Include, RangeOption.Equals, "100-100");

                // Add a second criteria (in this case the currency)
                //q.SelectionParameters["S_WAERS"].Ranges.Add(Sign.Include, RangeOption.Equals, "EUR");

                // Run the Query
                q.Execute();

                // Bind result to datagrid
                DataTable table = q.Result;

                Console.Read();
            }
        }

        private static void SendIDoc(R3Connection con, string matname, bool async)
        {
            using (con)
            {
                con.Open(false);

                ERPConnect.Idocs.Idoc id = con.CreateEmptyIdoc("MATMAS05", "");

                id.SNDPRN = "ERPTEST";
                id.SNDPRT = "LS";
                id.SNDPOR = "ERPTEST";
                id.RCVPRN = "BW_STDCLNT";
                id.RCVPRT = "LS";
                id.MESTYP = "MATMAS";

                // Idoc Segement E1MARAM 
                ERPConnect.Idocs.IdocSegment e1maram = id.CreateSegment("E1MARAM");
                e1maram.Fields["MATNR"].FieldValue = matname;
                e1maram.Fields["MTART"].FieldValue = "FERT";                
                e1maram.Fields["MEINS"].FieldValue = "PCE";
                e1maram.Fields["MBRSH"].FieldValue = "M";
                e1maram.Fields["BRGEW"].FieldValue = "1";
                e1maram.Fields["NTGEW"].FieldValue = "1";
                e1maram.Fields["GEWEI"].FieldValue = "KG";
                id.Segments.Add(e1maram);

                // Idoc Segement E1MAKTM 
                ERPConnect.Idocs.IdocSegment e1maktm = id.CreateSegment("E1MAKTM");
                e1maktm.Fields["SPRAS"].FieldValue = "E";
                e1maktm.Fields["MAKTX"].FieldValue = "my Article";
                e1maram.ChildSegments.Add(e1maktm);

                if (async)
                {
                    id.SendAndWait();
                    IdocStatus status = id.GetCurrentStatus();
                    Console.WriteLine(status.Status + "-> " + status.Description);
                }
                else
                {
                    id.Send();
                    Console.WriteLine("IDoc sent");
                }

                con.Close();
                Console.ReadLine();

            }
        }


        private static void RFCUserCreate(R3Connection con, string username)
        {

            using (con)
            {
                con.Open(false);

                RFCFunction func = con.CreateFunction("BAPI_USER_CREATE1");

                func.Exports["USERNAME"].ParamValue = username;
                func.Exports["GENERATE_PWD"].ParamValue = "X";

                RFCStructure ADDRESS = func.Exports["ADDRESS"].ToStructure();
                ADDRESS["FIRSTNAME"] = "FistName";
                ADDRESS["LASTNAME"] = "LastName";

                RFCStructure PASSWORD = func.Exports["PASSWORD"].ToStructure();
                PASSWORD["BAPIPWD"] = "init01";

                func.Execute();

                RFCStructure pw = func.Imports["GENERATED_PASSWORD"].ToStructure();
                string passw = pw["BAPIPWD"].ToString();

                Console.WriteLine("Password:" + passw);

                string message = func.Tables["RETURN"][0, "MESSAGE"].ToString();

                Console.WriteLine(message);
                Console.ReadLine();

                con.Close();
            }




        }

        private static void BapiGetFlightList(R3Connection con)
        {

            using (con)
            {
                con.Open(false);

                BusinessObjectMethod func = con.CreateBapi("Flight", "GetList");

                func.Exports["Airline"].ParamValue = "AA";
                
             
                func.Execute();


                DataTable table = func.Tables["FLIGHT_LIST"].ToADOTable();
                con.Close();

                Console.ReadLine();                
            }




        }
        private static void StartIDocServer()
        {

            try
            {
                
                RFCServer s = new RFCServer();
                s.Logging = true;
                //s.GatewayHost = "52.200.13.213";
                s.GatewayHost = "vhcals4hci.dummy.nodomain";
                s.GatewayService = "sapgw00";
                s.ProgramID = "ERPTEST";
                s.CanReceiveIdocs = true;
                s.IncomingIdoc += new ERPConnect.RFCServer.OnIncomingIdoc(s_IncomingIdoc);
                //s.IncomingIdoc += S_IncomingIdoc;
                //s.InternalException += new ERPConnect.RFCServer.OnInternalException(s_InternalException);
                

                s.Start();           
                Console.WriteLine("Server is running. Press any key to exit.");
                Console.ReadLine();
                s.Stop();
            }
            catch (Exception e1)
            {
                Console.WriteLine(e1.Message.ToString());
                Console.ReadLine();
            }
        }

        private static void StartRFCServer()
        {

            try
            {

                RFCServer s = new RFCServer();
                s.GatewayHost = "52.200.13.213";
                s.GatewayHost = "vhcals4hci.dummy.nodomain";
                //s.GatewayHost = "ec5.theobald-software.com";
                s.GatewayService = "sapgw00";
                s.ProgramID = "ERPTEST";
                s.IncomingCall += new ERPConnect.RFCServer.OnIncomingCall(s_IncomingCall);
                RFCServerFunction f = s.RegisteredFunctions.Add("Z_ADD");
                f.Imports.Add("NUMBER1", RFCTYPE.INT);
                f.Imports.Add("NUMBER2", RFCTYPE.INT);
                f.Exports.Add("RES", RFCTYPE.INT);
        

                s.Start();
                Console.WriteLine("Server is running. Press any key to exit.");
                Console.ReadLine();
                s.Stop();
            }
            catch (Exception e1)
            {
                Console.WriteLine(e1.Message.ToString());
                Console.ReadLine();
            }
        }

        private static void s_IncomingIdoc(RFCServer sender, Idoc idoc)
        {
            Console.WriteLine("Recieved Idoc " + idoc.IDOCTYP);
            IdocSegment e1maram = idoc.Segments["E2MARAM008", 0];
            for (int i = 0; i < e1maram.ChildSegments.Count; i++)
                if (e1maram.ChildSegments[i].SegmentName == "E2MAKTM001")
                    Console.WriteLine("Materialtext found: " +
                        e1maram.ChildSegments[i].ReadDataBuffer(4, 40));
        }


        private static void s_IncomingCall(RFCServer Sender, RFCServerFunction CalledFunction)
        {
            if (CalledFunction.FunctionName == "Z_ADD")
            {
                Int32 i1 = (Int32)CalledFunction.Imports["NUMBER1"].ParamValue;
                Int32 i2 = (Int32)CalledFunction.Imports["NUMBER2"].ParamValue;
                Int32 erg = i1 + i2;
                CalledFunction.Exports["RES"].ParamValue = erg;
                Console.WriteLine("Incoming Call");
                Console.WriteLine(i1 + " + " + i2 + " = " + erg);
            }
            else
              throw new ERPConnect.ERPException("Function unknown");
        }

    }



}
