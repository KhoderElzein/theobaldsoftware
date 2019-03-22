using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;


namespace DocumentGenerator
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            int surahnr = Int32.Parse(cb_surah.SelectedItem.ToString());
            HelloWorld(surahnr);
            //HelloWorld(@"C:\Data\surah-" + cb_surah.SelectedItem + ".docx");
        }

        public void HelloWorld(Int32 SurahNr)
        {
            var basmala = @"بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";
            string docName = @"C:\Data\surah-" + SurahNr + ".docx";
            // Create a Wordprocessing document. 
            using (WordprocessingDocument mydoc = WordprocessingDocument.Create(docName, WordprocessingDocumentType.Document))
            {


                // Add a new main document part. 
                MainDocumentPart mainPart = mydoc.AddMainDocumentPart();
                //Create DOM tree for simple document. 
                mainPart.Document = new Document();
                Body body = new Body();
                Paragraph p = new Paragraph();
                ParagraphProperties pp = p.ChildElements.First<ParagraphProperties>();

                if (pp == null)
                {
                    pp = new ParagraphProperties();
                    p.Append(pp);
                    //p.InsertBefore(pp, p.First());
                }

                BiDi bidi = new BiDi();
                pp.Append(bidi);
                Run r = new Run();
                Text t; // = new Text(ayah.AyahText);
                Table table = new Table();
                //Quran ayah;
                using (var context = new DBEntities())
                {

                    TableProperties props = new TableProperties(
      new TableBorders(
        new TopBorder
        {
            Val = new EnumValue<BorderValues>(BorderValues.Single),
            Size = 12
        },
        new BottomBorder
        {
            Val = new EnumValue<BorderValues>(BorderValues.Single),
            Size = 11
        },
        new LeftBorder
        {
            Val = new EnumValue<BorderValues>(BorderValues.Single),
            Size = 11
        },
        new RightBorder
        {
            Val = new EnumValue<BorderValues>(BorderValues.Single),
            Size = 11
        },
        new InsideHorizontalBorder
        {
            Val = new EnumValue<BorderValues>(BorderValues.Single),
            Size = 11
        },
        new InsideVerticalBorder
        {
            Val = new EnumValue<BorderValues>(BorderValues.Single),
            Size = 11
        }));

                    table.AppendChild<TableProperties>(props);

                    //var ayah = context.Qurans.Where(q => q.SuraID == 112 && q.VerseID == 2).FirstOrDefault<Quran>();
            
                    var ayah = from a in context.Qurans where a.SuraID.Equals(SurahNr) select a;
                    foreach (var a in ayah)
                    {
                        var tr = new TableRow();
                        var ayahT = a.AyahText;
                        if (a.VerseID == 1)
                        {
                            ayahT =  ayahT.Remove(0,basmala.Length);
                        }
                        var tc = new TableCell();
                        tc.Append(new Paragraph(new Run(new Text(ayahT))));

                        //var p2 = new Paragraph();
                        //pp = p2.ChildElements.First<ParagraphProperties>();
                        //if (pp == null)
                        //{
                        //    pp = new ParagraphProperties();
                        //    p.Append(pp);
                        //    //p.InsertBefore(pp, p.First());
                        //}

                        //bidi = new BiDi();
                        //pp.Append(bidi);
                        //r = new Run();
                        //t = new Text(a.AyahText);
                        //tc.Append(p2);
                        //tc.Append(new Paragraph(new Run(new Text(a.VerseID.ToString()))));
                        tr.Append(tc);

                        tc = new TableCell();
                        //tc.Append(new Paragraph(new Run(new Text(a.AyahText))));
                        tc.Append(new Paragraph(new Run(new Text(a.VerseID.ToString()))));

                        //p2 = new Paragraph();
                        //pp = p2.ChildElements.First<ParagraphProperties>();
                        //if (pp == null)
                        //{
                        //    pp = new ParagraphProperties();
                        //    p.Append(pp);
                        //    //p.InsertBefore(pp, p.First());
                        //}

                        //bidi = new BiDi();
                        //pp.Append(bidi);
                        //r = new Run();
                        //t = new Text(a.VerseID.ToString());
                        //tc.Append(p2);


                        tr.Append(tc);
                        table.Append(tr);

                        //t = new Text(a.VerseID + ": " +  a.AyahText);
                        //r.Append(t);
                        //r.AppendChild(new Break());
                    }
                }
                //Append elements appropriately. 
                //r.Append(t);
                p.Append(r);
                body.Append(table);
                body.Append(p);
                mainPart.Document.Append(body);
                // Save changes to the main document part. 
                mainPart.Document.Save();

                // Save changes to the main document part. 
                mydoc.MainDocumentPart.Document.Save();
            }
        }

    }
}
