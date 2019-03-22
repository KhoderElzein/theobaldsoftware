using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentGenerator
{
    public class DataReader
    {
        public static IQueryable<Quran> GetSurah(int SurahNr)
        {
            var context = new DBEntities();
            var ayah = from a in context.Qurans where a.SuraID.Equals(SurahNr) select a;
            return ayah;
        }
    }
}
