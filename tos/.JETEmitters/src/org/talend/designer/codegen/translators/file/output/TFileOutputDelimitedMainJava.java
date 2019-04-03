package org.talend.designer.codegen.translators.file.output;

import org.talend.core.model.process.INode;
import org.talend.core.model.process.ElementParameterParser;
import org.talend.core.model.metadata.IMetadataTable;
import org.talend.core.model.metadata.IMetadataColumn;
import org.talend.core.model.process.IConnection;
import org.talend.core.model.process.IConnectionCategory;
import org.talend.designer.codegen.config.CodeGeneratorArgument;
import java.util.List;
import org.talend.core.model.metadata.types.JavaTypesManager;
import org.talend.core.model.metadata.types.JavaType;
import org.talend.core.model.utils.NodeUtil;
import org.talend.core.model.process.AbstractNode;

public class TFileOutputDelimitedMainJava
{
  protected static String nl;
  public static synchronized TFileOutputDelimitedMainJava create(String lineSeparator)
  {
    nl = lineSeparator;
    TFileOutputDelimitedMainJava result = new TFileOutputDelimitedMainJava();
    nl = null;
    return result;
  }

  public final String NL = nl == null ? (System.getProperties().getProperty("line.separator")) : nl;
  protected final String TEXT_1 = "";
  protected final String TEXT_2 = NL;
  protected final String TEXT_3 = NL + "                    StringBuilder sb_";
  protected final String TEXT_4 = " = new StringBuilder();";
  protected final String TEXT_5 = NL + "                synchronized (multiThreadLockWrite) {";
  protected final String TEXT_6 = NL + "                synchronized ((Object[])globalMap.get(\"lockWrite_";
  protected final String TEXT_7 = "\")) {";
  protected final String TEXT_8 = NL + "                Object[] pLockWrite = (Object[])globalMap.get(\"PARALLEL_LOCK_WRITE\");" + NL + "                synchronized (pLockWrite) {";
  protected final String TEXT_9 = NL + "                    if(isFirstCheckDyn_";
  protected final String TEXT_10 = " ";
  protected final String TEXT_11 = "&& (file_";
  protected final String TEXT_12 = ".length()==0)";
  protected final String TEXT_13 = "){";
  protected final String TEXT_14 = NL + "                    if(isFirstCheckDyn_";
  protected final String TEXT_15 = " ";
  protected final String TEXT_16 = "&& file";
  protected final String TEXT_17 = ".length()==0";
  protected final String TEXT_18 = "){";
  protected final String TEXT_19 = NL + "                                    fileOutputDelimitedUtil_";
  protected final String TEXT_20 = ".putHeaderValue_";
  protected final String TEXT_21 = "(out";
  protected final String TEXT_22 = ",OUT_DELIM_";
  protected final String TEXT_23 = ", ";
  protected final String TEXT_24 = ");";
  protected final String TEXT_25 = NL + "                        out";
  protected final String TEXT_26 = ".write(\"";
  protected final String TEXT_27 = "\");";
  protected final String TEXT_28 = NL + "                        routines.system.DynamicUtils.writeHeaderToDelimitedFile(";
  protected final String TEXT_29 = ".";
  protected final String TEXT_30 = ", out";
  protected final String TEXT_31 = ", OUT_DELIM_";
  protected final String TEXT_32 = ");";
  protected final String TEXT_33 = NL + "                        out";
  protected final String TEXT_34 = ".write(OUT_DELIM_";
  protected final String TEXT_35 = ");";
  protected final String TEXT_36 = NL + "                        out";
  protected final String TEXT_37 = ".write(OUT_DELIM_ROWSEP_";
  protected final String TEXT_38 = ");" + NL + "                        isFirstCheckDyn_";
  protected final String TEXT_39 = " = false;" + NL + "                    }";
  protected final String TEXT_40 = NL + "                }";
  protected final String TEXT_41 = NL + "                }";
  protected final String TEXT_42 = NL + "                }";
  protected final String TEXT_43 = NL + "                            fileOutputDelimitedUtil_";
  protected final String TEXT_44 = ".putValue_";
  protected final String TEXT_45 = "(";
  protected final String TEXT_46 = ",sb_";
  protected final String TEXT_47 = ",OUT_DELIM_";
  protected final String TEXT_48 = ");";
  protected final String TEXT_49 = NL + "                            if(";
  protected final String TEXT_50 = ".";
  protected final String TEXT_51 = " != null) {";
  protected final String TEXT_52 = NL + "                            routines.system.DynamicUtils.writeValuesToStringBuilder(";
  protected final String TEXT_53 = ".";
  protected final String TEXT_54 = ", sb_";
  protected final String TEXT_55 = ", OUT_DELIM_";
  protected final String TEXT_56 = ", ";
  protected final String TEXT_57 = ", ";
  protected final String TEXT_58 = ");";
  protected final String TEXT_59 = NL + "\t\t\t\t\t\t\troutines.system.DynamicUtils.writeValuesToStringBuilder(";
  protected final String TEXT_60 = ".";
  protected final String TEXT_61 = ", sb_";
  protected final String TEXT_62 = ", OUT_DELIM_";
  protected final String TEXT_63 = ");" + NL + "\t\t\t\t\t\t\t";
  protected final String TEXT_64 = NL + "                        sb_";
  protected final String TEXT_65 = ".append(";
  protected final String TEXT_66 = NL + "                            FormatterUtils.format_Date(";
  protected final String TEXT_67 = ".";
  protected final String TEXT_68 = ", ";
  protected final String TEXT_69 = ")";
  protected final String TEXT_70 = NL + "                                    FormatterUtils.format_Number(";
  protected final String TEXT_71 = ".toPlainString(), ";
  protected final String TEXT_72 = ", ";
  protected final String TEXT_73 = ")";
  protected final String TEXT_74 = NL + "                                    FormatterUtils.format_Number(new java.math.BigDecimal(String.valueOf(";
  protected final String TEXT_75 = ".";
  protected final String TEXT_76 = ")).toPlainString(), ";
  protected final String TEXT_77 = ", ";
  protected final String TEXT_78 = ")";
  protected final String TEXT_79 = NL + "                            ";
  protected final String TEXT_80 = ".toPlainString()";
  protected final String TEXT_81 = NL + "                            java.nio.charset.Charset.forName(";
  protected final String TEXT_82 = ").decode(java.nio.ByteBuffer.wrap(";
  protected final String TEXT_83 = ".";
  protected final String TEXT_84 = ")).toString()";
  protected final String TEXT_85 = NL + "                            ";
  protected final String TEXT_86 = ".";
  protected final String TEXT_87 = NL + "                        );";
  protected final String TEXT_88 = NL + "                            }";
  protected final String TEXT_89 = NL + "                            sb_";
  protected final String TEXT_90 = ".append(OUT_DELIM_";
  protected final String TEXT_91 = ");";
  protected final String TEXT_92 = NL + "                    sb_";
  protected final String TEXT_93 = ".append(OUT_DELIM_ROWSEP_";
  protected final String TEXT_94 = ");" + NL + NL;
  protected final String TEXT_95 = NL + "                    synchronized (multiThreadLockWrite) {";
  protected final String TEXT_96 = NL + "                    synchronized ((Object[])globalMap.get(\"lockWrite_";
  protected final String TEXT_97 = "\")) {";
  protected final String TEXT_98 = NL + "                    Object[] pLockWrite = (Object[])globalMap.get(\"PARALLEL_LOCK_WRITE\");" + NL + "                    synchronized (pLockWrite) {";
  protected final String TEXT_99 = NL + "                    nb_line_";
  protected final String TEXT_100 = "++;" + NL + "                    resourceMap.put(\"nb_line_";
  protected final String TEXT_101 = "\", nb_line_";
  protected final String TEXT_102 = ");";
  protected final String TEXT_103 = NL + "                        if(currentRow_";
  protected final String TEXT_104 = " % splitEvery_";
  protected final String TEXT_105 = "==0 && currentRow_";
  protected final String TEXT_106 = "!=0){" + NL + "                            splitedFileNo_";
  protected final String TEXT_107 = "++;" + NL + "                            out";
  protected final String TEXT_108 = ".close();" + NL + "                            //close original outputStream" + NL + "" + NL + "                            file";
  protected final String TEXT_109 = " = new java.io.File(fullName_";
  protected final String TEXT_110 = " + splitedFileNo_";
  protected final String TEXT_111 = " + extension_";
  protected final String TEXT_112 = ");" + NL;
  protected final String TEXT_113 = NL + "                            if(file";
  protected final String TEXT_114 = ".exists()) {" + NL + "                                file";
  protected final String TEXT_115 = ".delete();" + NL + "                            }";
  protected final String TEXT_116 = NL + "                            out";
  protected final String TEXT_117 = " = new ";
  protected final String TEXT_118 = "(new java.io.OutputStreamWriter(" + NL + "                                    new java.io.FileOutputStream(fullName_";
  protected final String TEXT_119 = " + splitedFileNo_";
  protected final String TEXT_120 = " + extension_";
  protected final String TEXT_121 = ", ";
  protected final String TEXT_122 = "),";
  protected final String TEXT_123 = "));";
  protected final String TEXT_124 = NL + "                                if(file";
  protected final String TEXT_125 = ".length()==0){";
  protected final String TEXT_126 = NL + "                                        fileOutputDelimitedUtil_";
  protected final String TEXT_127 = ".putHeaderValue_";
  protected final String TEXT_128 = "(out";
  protected final String TEXT_129 = ",OUT_DELIM_";
  protected final String TEXT_130 = ", ";
  protected final String TEXT_131 = ");";
  protected final String TEXT_132 = NL + "                                        out";
  protected final String TEXT_133 = ".write(\"";
  protected final String TEXT_134 = "\");";
  protected final String TEXT_135 = NL + "                                        routines.system.DynamicUtils.writeHeaderToDelimitedFile(";
  protected final String TEXT_136 = ".";
  protected final String TEXT_137 = ", out";
  protected final String TEXT_138 = ", OUT_DELIM_";
  protected final String TEXT_139 = ");";
  protected final String TEXT_140 = NL + "                                            out";
  protected final String TEXT_141 = ".write(OUT_DELIM_";
  protected final String TEXT_142 = ");";
  protected final String TEXT_143 = NL + "                                    out";
  protected final String TEXT_144 = ".write(OUT_DELIM_ROWSEP_";
  protected final String TEXT_145 = ");" + NL + "                                }";
  protected final String TEXT_146 = NL + "                            out";
  protected final String TEXT_147 = ".write(sb_";
  protected final String TEXT_148 = ".toString());";
  protected final String TEXT_149 = NL + "                                if(nb_line_";
  protected final String TEXT_150 = "%";
  protected final String TEXT_151 = " == 0) {" + NL + "                                out";
  protected final String TEXT_152 = ".flush();" + NL + "                                }";
  protected final String TEXT_153 = NL + "                        }else{" + NL + "                            out";
  protected final String TEXT_154 = ".write(sb_";
  protected final String TEXT_155 = ".toString());";
  protected final String TEXT_156 = NL + "                                if(nb_line_";
  protected final String TEXT_157 = "%";
  protected final String TEXT_158 = " == 0) {" + NL + "                                out";
  protected final String TEXT_159 = ".flush();" + NL + "                                }";
  protected final String TEXT_160 = NL + "                        }" + NL + "                        currentRow_";
  protected final String TEXT_161 = "++;" + NL + NL;
  protected final String TEXT_162 = NL + NL + "                        out";
  protected final String TEXT_163 = ".write(sb_";
  protected final String TEXT_164 = ".toString());";
  protected final String TEXT_165 = NL + "                                if(nb_line_";
  protected final String TEXT_166 = "%";
  protected final String TEXT_167 = " == 0) {" + NL + "                                out";
  protected final String TEXT_168 = ".flush();" + NL + "                                }";
  protected final String TEXT_169 = NL + "                        log.debug(\"";
  protected final String TEXT_170 = " - Writing the record \" + nb_line_";
  protected final String TEXT_171 = " + \".\");";
  protected final String TEXT_172 = NL;
  protected final String TEXT_173 = NL + "                    }";
  protected final String TEXT_174 = NL + "                    }";
  protected final String TEXT_175 = NL + "                    }";
  protected final String TEXT_176 = NL;
  protected final String TEXT_177 = NL;
  protected final String TEXT_178 = NL;
  protected final String TEXT_179 = NL + "                dynamic_column_count_";
  protected final String TEXT_180 = " = 1;";
  protected final String TEXT_181 = NL + "                    synchronized (multiThreadLockWrite) {";
  protected final String TEXT_182 = NL + "                    synchronized ((Object[])globalMap.get(\"lockWrite_";
  protected final String TEXT_183 = "\")) {";
  protected final String TEXT_184 = NL + "                    Object[] pLockWrite = (Object[])globalMap.get(\"PARALLEL_LOCK_WRITE\");" + NL + "                    synchronized (pLockWrite) {";
  protected final String TEXT_185 = NL + "                        if(isFirstCheckDyn_";
  protected final String TEXT_186 = " ";
  protected final String TEXT_187 = "&& (file_";
  protected final String TEXT_188 = ".length()==0)";
  protected final String TEXT_189 = "){" + NL + "                            headColu";
  protected final String TEXT_190 = " = new String[";
  protected final String TEXT_191 = "-1+";
  protected final String TEXT_192 = ".";
  protected final String TEXT_193 = ".getColumnCount()];";
  protected final String TEXT_194 = NL + "                        if(isFirstCheckDyn_";
  protected final String TEXT_195 = " ";
  protected final String TEXT_196 = "&& file";
  protected final String TEXT_197 = ".length()==0";
  protected final String TEXT_198 = "){" + NL + "                            headColu";
  protected final String TEXT_199 = " = new String[";
  protected final String TEXT_200 = "-1+";
  protected final String TEXT_201 = ".";
  protected final String TEXT_202 = ".getColumnCount()];";
  protected final String TEXT_203 = NL + "                                    dynamic_column_count_";
  protected final String TEXT_204 = " = ";
  protected final String TEXT_205 = ".";
  protected final String TEXT_206 = ".getColumnCount();";
  protected final String TEXT_207 = NL + "                                    fileOutputDelimitedUtil_";
  protected final String TEXT_208 = ".putHeaderValue_";
  protected final String TEXT_209 = "(headColu";
  protected final String TEXT_210 = ", ";
  protected final String TEXT_211 = ",dynamic_column_count_";
  protected final String TEXT_212 = ");";
  protected final String TEXT_213 = NL + "                            headColu";
  protected final String TEXT_214 = "[";
  protected final String TEXT_215 = "+dynamic_column_count_";
  protected final String TEXT_216 = "]=\"";
  protected final String TEXT_217 = "\";";
  protected final String TEXT_218 = NL + "                            headColu";
  protected final String TEXT_219 = "[";
  protected final String TEXT_220 = "]=\"";
  protected final String TEXT_221 = "\";";
  protected final String TEXT_222 = NL + "                             for(int mi=0;mi<dynamic_column_count_";
  protected final String TEXT_223 = ";mi++){" + NL + "                                headColu";
  protected final String TEXT_224 = "[";
  protected final String TEXT_225 = "+mi]=";
  protected final String TEXT_226 = ".";
  protected final String TEXT_227 = ".getColumnMetadata(mi).getName();" + NL + "                             }";
  protected final String TEXT_228 = NL + "                            CsvWriter";
  protected final String TEXT_229 = ".writeNext(headColu";
  protected final String TEXT_230 = ");" + NL + "                            CsvWriter";
  protected final String TEXT_231 = ".flush();";
  protected final String TEXT_232 = NL + "                            out";
  protected final String TEXT_233 = ".write(strWriter";
  protected final String TEXT_234 = ".getBuffer().toString());" + NL + "                            out";
  protected final String TEXT_235 = ".flush();" + NL + "                            strWriter";
  protected final String TEXT_236 = ".getBuffer().delete(0, strWriter";
  protected final String TEXT_237 = ".getBuffer().length());";
  protected final String TEXT_238 = NL + "                        }";
  protected final String TEXT_239 = NL + "                    }";
  protected final String TEXT_240 = NL + "                    }";
  protected final String TEXT_241 = NL + "                    }";
  protected final String TEXT_242 = NL + "                        if(isFirstCheckDyn_";
  protected final String TEXT_243 = "){" + NL + "                            CsvWriter";
  protected final String TEXT_244 = ".setEscapeChar(csvSettings_";
  protected final String TEXT_245 = ".getEscapeChar());" + NL + "                            CsvWriter";
  protected final String TEXT_246 = ".setQuoteChar(csvSettings_";
  protected final String TEXT_247 = ".getTextEnclosure());" + NL + "                            CsvWriter";
  protected final String TEXT_248 = ".setQuoteStatus(com.talend.csv.CSVWriter.QuoteStatus.FORCE);" + NL + "                            isFirstCheckDyn_";
  protected final String TEXT_249 = " = false;" + NL + "                        }";
  protected final String TEXT_250 = NL + "                        String[] row";
  protected final String TEXT_251 = "=new String[";
  protected final String TEXT_252 = "];";
  protected final String TEXT_253 = NL + "                        dynamic_column_count_";
  protected final String TEXT_254 = " =1;";
  protected final String TEXT_255 = NL + "                                dynamic_column_count_";
  protected final String TEXT_256 = " = ";
  protected final String TEXT_257 = ".";
  protected final String TEXT_258 = ".getColumnCount();";
  protected final String TEXT_259 = NL + "                                fileOutputDelimitedUtil_";
  protected final String TEXT_260 = ".putValue_";
  protected final String TEXT_261 = "(";
  protected final String TEXT_262 = ",row";
  protected final String TEXT_263 = ",dynamic_column_count_";
  protected final String TEXT_264 = " ";
  protected final String TEXT_265 = ");";
  protected final String TEXT_266 = NL + "                            if (";
  protected final String TEXT_267 = ".";
  protected final String TEXT_268 = " != null) {" + NL + "                                routines.system.DynamicUtils.writeValuesToStringArrayEnhance(";
  protected final String TEXT_269 = ".";
  protected final String TEXT_270 = ", row";
  protected final String TEXT_271 = ", ";
  protected final String TEXT_272 = ",";
  protected final String TEXT_273 = NL + "                                           \"";
  protected final String TEXT_274 = "\"";
  protected final String TEXT_275 = NL + "                                           null";
  protected final String TEXT_276 = NL + "                                );" + NL + "                            }";
  protected final String TEXT_277 = NL + "                            row";
  protected final String TEXT_278 = "[";
  protected final String TEXT_279 = "+dynamic_column_count_";
  protected final String TEXT_280 = "]=";
  protected final String TEXT_281 = NL + "                            row";
  protected final String TEXT_282 = "[";
  protected final String TEXT_283 = "]=";
  protected final String TEXT_284 = ".";
  protected final String TEXT_285 = ";";
  protected final String TEXT_286 = "FormatterUtils.format_Date(";
  protected final String TEXT_287 = ".";
  protected final String TEXT_288 = ", ";
  protected final String TEXT_289 = ");";
  protected final String TEXT_290 = "java.nio.charset.Charset.defaultCharset().decode(java.nio.ByteBuffer.wrap(";
  protected final String TEXT_291 = ".";
  protected final String TEXT_292 = ")).toString();";
  protected final String TEXT_293 = "FormatterUtils.format_Number(";
  protected final String TEXT_294 = ".toPlainString(), ";
  protected final String TEXT_295 = ", ";
  protected final String TEXT_296 = ");";
  protected final String TEXT_297 = "FormatterUtils.format_Number(new java.math.BigDecimal(String.valueOf(";
  protected final String TEXT_298 = ".";
  protected final String TEXT_299 = ")).toPlainString(), ";
  protected final String TEXT_300 = ", ";
  protected final String TEXT_301 = ");";
  protected final String TEXT_302 = ".toPlainString();";
  protected final String TEXT_303 = "String.valueOf(";
  protected final String TEXT_304 = ".";
  protected final String TEXT_305 = ");";
  protected final String TEXT_306 = NL + "                synchronized (multiThreadLockWrite) {";
  protected final String TEXT_307 = NL + "                synchronized ((Object[])globalMap.get(\"lockWrite_";
  protected final String TEXT_308 = "\")) {";
  protected final String TEXT_309 = NL + "                Object[] pLockWrite = (Object[])globalMap.get(\"PARALLEL_LOCK_WRITE\");" + NL + "                synchronized (pLockWrite) {";
  protected final String TEXT_310 = NL + "                nb_line_";
  protected final String TEXT_311 = "++;" + NL + "                resourceMap.put(\"nb_line_";
  protected final String TEXT_312 = "\", nb_line_";
  protected final String TEXT_313 = ");";
  protected final String TEXT_314 = NL + "                            if(currentRow_";
  protected final String TEXT_315 = " % splitEvery_";
  protected final String TEXT_316 = "==0 && currentRow_";
  protected final String TEXT_317 = "!=0){" + NL + "                                splitedFileNo_";
  protected final String TEXT_318 = "++;" + NL + "                                CsvWriter";
  protected final String TEXT_319 = ".close();" + NL + "                                //close original outputStream" + NL;
  protected final String TEXT_320 = NL + "                                java.io.File fileToDelete_";
  protected final String TEXT_321 = " = new java.io.File(fullName_";
  protected final String TEXT_322 = " + splitedFileNo_";
  protected final String TEXT_323 = " + extension_";
  protected final String TEXT_324 = ");" + NL + "                                if(fileToDelete_";
  protected final String TEXT_325 = ".exists()) {" + NL + "                                    fileToDelete_";
  protected final String TEXT_326 = ".delete();" + NL + "                                }";
  protected final String TEXT_327 = NL;
  protected final String TEXT_328 = NL + "                                out";
  protected final String TEXT_329 = ".close();" + NL + "                                out";
  protected final String TEXT_330 = " = new routines.system.BufferedOutput(new java.io.OutputStreamWriter(" + NL + "                                    new java.io.FileOutputStream(fullName_";
  protected final String TEXT_331 = " + splitedFileNo_";
  protected final String TEXT_332 = " + extension_";
  protected final String TEXT_333 = ", ";
  protected final String TEXT_334 = "),";
  protected final String TEXT_335 = "));" + NL + "                                strWriter";
  protected final String TEXT_336 = " = new java.io.StringWriter();" + NL + "                                CsvWriter";
  protected final String TEXT_337 = " = new com.talend.csv.CSVWriter(strWriter";
  protected final String TEXT_338 = ");" + NL + "                                CsvWriter";
  protected final String TEXT_339 = ".setSeparator(csvSettings_";
  protected final String TEXT_340 = ".getFieldDelim());";
  protected final String TEXT_341 = NL + "                                CsvWriter";
  protected final String TEXT_342 = " = new com.talend.csv.CSVWriter(new java.io.BufferedWriter(new java.io.OutputStreamWriter(" + NL + "                                    new java.io.FileOutputStream(fullName_";
  protected final String TEXT_343 = " + splitedFileNo_";
  protected final String TEXT_344 = " + extension_";
  protected final String TEXT_345 = ", ";
  protected final String TEXT_346 = "),";
  protected final String TEXT_347 = ")));" + NL + "                                CsvWriter";
  protected final String TEXT_348 = ".setSeparator(csvSettings_";
  protected final String TEXT_349 = ".getFieldDelim());";
  protected final String TEXT_350 = NL;
  protected final String TEXT_351 = NL + "                                if(csvSettings_";
  protected final String TEXT_352 = ".isUseCRLFRecordDelimiter()) {" + NL + "                                    CsvWriter";
  protected final String TEXT_353 = ".setLineEnd(\"\\r\\n\");" + NL + "                                } else {" + NL + "                                    CsvWriter";
  protected final String TEXT_354 = ".setLineEnd(\"\"+csvSettings_";
  protected final String TEXT_355 = ".getRowDelim());" + NL + "                                }";
  protected final String TEXT_356 = NL + "                                if(!csvSettings_";
  protected final String TEXT_357 = ".isUseCRLFRecordDelimiter() && csvSettings_";
  protected final String TEXT_358 = ".getRowDelim()!='\\r' && csvSettings_";
  protected final String TEXT_359 = ".getRowDelim()!='\\n') {" + NL + "                                    CsvWriter";
  protected final String TEXT_360 = ".setLineEnd(\"\"+csvSettings_";
  protected final String TEXT_361 = ".getRowDelim());" + NL + "                                }";
  protected final String TEXT_362 = NL + NL + "                                //set header.";
  protected final String TEXT_363 = NL + "                                    CsvWriter";
  protected final String TEXT_364 = ".writeNext(headColu";
  protected final String TEXT_365 = ");";
  protected final String TEXT_366 = NL + "                                    out";
  protected final String TEXT_367 = ".write(strWriter";
  protected final String TEXT_368 = ".getBuffer().toString());" + NL + "                                    strWriter";
  protected final String TEXT_369 = ".getBuffer().delete(0, strWriter";
  protected final String TEXT_370 = ".getBuffer().length());";
  protected final String TEXT_371 = NL + "                                    file";
  protected final String TEXT_372 = " = new java.io.File(fullName_";
  protected final String TEXT_373 = " + splitedFileNo_";
  protected final String TEXT_374 = " + extension_";
  protected final String TEXT_375 = ");" + NL + "                                    if(file";
  protected final String TEXT_376 = ".length() == 0) {" + NL + "                                        CsvWriter";
  protected final String TEXT_377 = ".writeNext(headColu";
  protected final String TEXT_378 = ");";
  protected final String TEXT_379 = NL + "                                        out";
  protected final String TEXT_380 = ".write(strWriter";
  protected final String TEXT_381 = ".getBuffer().toString());" + NL + "                                        strWriter";
  protected final String TEXT_382 = ".getBuffer().delete(0, strWriter";
  protected final String TEXT_383 = ".getBuffer().length());";
  protected final String TEXT_384 = NL + "                                    }";
  protected final String TEXT_385 = NL + "                                //initialize new CsvWriter information" + NL + "                                CsvWriter";
  protected final String TEXT_386 = ".setEscapeChar(csvSettings_";
  protected final String TEXT_387 = ".getEscapeChar());" + NL + "                                CsvWriter";
  protected final String TEXT_388 = ".setQuoteChar(csvSettings_";
  protected final String TEXT_389 = ".getTextEnclosure());" + NL + "                                CsvWriter";
  protected final String TEXT_390 = ".setQuoteStatus(com.talend.csv.CSVWriter.QuoteStatus.FORCE);" + NL + "" + NL + "                                           CsvWriter";
  protected final String TEXT_391 = ".writeNext(row";
  protected final String TEXT_392 = ");";
  protected final String TEXT_393 = NL + "                                out";
  protected final String TEXT_394 = ".write(strWriter";
  protected final String TEXT_395 = ".getBuffer().toString());" + NL + "                                strWriter";
  protected final String TEXT_396 = ".getBuffer().delete(0, strWriter";
  protected final String TEXT_397 = ".getBuffer().length());";
  protected final String TEXT_398 = NL + "                                    if(nb_line_";
  protected final String TEXT_399 = "%";
  protected final String TEXT_400 = " == 0) {";
  protected final String TEXT_401 = NL + "                                    out";
  protected final String TEXT_402 = ".flush();";
  protected final String TEXT_403 = NL + "                                    CsvWriter";
  protected final String TEXT_404 = ".flush();";
  protected final String TEXT_405 = NL + "                                    }";
  protected final String TEXT_406 = NL + NL + "                            }else{" + NL + "                                           CsvWriter";
  protected final String TEXT_407 = ".writeNext(row";
  protected final String TEXT_408 = ");";
  protected final String TEXT_409 = NL + "                                out";
  protected final String TEXT_410 = ".write(strWriter";
  protected final String TEXT_411 = ".getBuffer().toString());" + NL + "                                strWriter";
  protected final String TEXT_412 = ".getBuffer().delete(0, strWriter";
  protected final String TEXT_413 = ".getBuffer().length());";
  protected final String TEXT_414 = NL + "                                    if(nb_line_";
  protected final String TEXT_415 = "%";
  protected final String TEXT_416 = " == 0) {";
  protected final String TEXT_417 = NL + "                                    out";
  protected final String TEXT_418 = ".flush();";
  protected final String TEXT_419 = NL + "                                    CsvWriter";
  protected final String TEXT_420 = ".flush();";
  protected final String TEXT_421 = NL + "                                    }";
  protected final String TEXT_422 = NL + "                            }" + NL + "                            currentRow_";
  protected final String TEXT_423 = "++;";
  protected final String TEXT_424 = NL + "                                       CsvWriter";
  protected final String TEXT_425 = ".writeNextEnhance(row";
  protected final String TEXT_426 = ",\"";
  protected final String TEXT_427 = "\");";
  protected final String TEXT_428 = NL + "                                       CsvWriter";
  protected final String TEXT_429 = ".writeNext(row";
  protected final String TEXT_430 = ");";
  protected final String TEXT_431 = NL + "                            out";
  protected final String TEXT_432 = ".write(strWriter";
  protected final String TEXT_433 = ".getBuffer().toString());" + NL + "                            strWriter";
  protected final String TEXT_434 = ".getBuffer().delete(0, strWriter";
  protected final String TEXT_435 = ".getBuffer().length());";
  protected final String TEXT_436 = NL + "                                    if(nb_line_";
  protected final String TEXT_437 = "%";
  protected final String TEXT_438 = " == 0) {";
  protected final String TEXT_439 = NL + "                                    out";
  protected final String TEXT_440 = ".flush();";
  protected final String TEXT_441 = NL + "                                    CsvWriter";
  protected final String TEXT_442 = ".flush();";
  protected final String TEXT_443 = NL + "                                    }";
  protected final String TEXT_444 = NL + "                            log.debug(\"";
  protected final String TEXT_445 = " - Writing the record \" + nb_line_";
  protected final String TEXT_446 = " + \".\");";
  protected final String TEXT_447 = NL;
  protected final String TEXT_448 = NL + "                }";
  protected final String TEXT_449 = NL + "                }";
  protected final String TEXT_450 = NL + "                }";
  protected final String TEXT_451 = NL;
  protected final String TEXT_452 = NL;
  protected final String TEXT_453 = NL;

  public String generate(Object argument)
  {
    final StringBuffer stringBuffer = new StringBuffer();
    stringBuffer.append(TEXT_1);
    
CodeGeneratorArgument codeGenArgument = (CodeGeneratorArgument) argument;
INode node = (INode)codeGenArgument.getArgument();
String cid = node.getUniqueName();

boolean isTSalesforceWaveOutputBulkExec = ((cid == null) ? false : (cid.startsWith("tSalesforceWaveOutputBulkExec")));
boolean useDoubleQuoteEnclosure = "true".equals(ElementParameterParser.getValue(node,"__CSV_OPTION__"))
                                  && ("\"\"\"").equals(ElementParameterParser.getValue(node, "__TEXT_ENCLOSURE__"));
boolean applyNA4Null = isTSalesforceWaveOutputBulkExec;
String str4Nil = "#N/A";

boolean useStream = ("true").equals(ElementParameterParser.getValue(node,"__USESTREAM__"));
int schemaOptNum=100;
String schemaOptNumStr=ElementParameterParser.getValue(node, "__SCHEMA_OPT_NUM__");
if(schemaOptNumStr!=null && !"".equals(schemaOptNumStr) && !"\"\"".equals(schemaOptNumStr)){
    schemaOptNum  = Integer.parseInt(schemaOptNumStr);
}
int dynamic_column_index=-1;
boolean isLog4jEnabled = ("true").equals(ElementParameterParser.getValue(node.getProcess(), "__LOG4J_ACTIVATE__"));
if(("false").equals(ElementParameterParser.getValue(node,"__CSV_OPTION__"))) {
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    stringBuffer.append(TEXT_2);
    

    List<IMetadataTable> metadatas = node.getMetadataList();
    if ((metadatas!=null)&&(metadatas.size()>0)) {
        IMetadataTable metadata = metadatas.get(0);
        if (metadata!=null) {


            String encoding = ElementParameterParser.getValue(
                node,
                "__ENCODING__"
            );

            boolean isAppend = ("true").equals(ElementParameterParser.getValue(node,"__APPEND__"));

            boolean isIncludeHeader = ("true").equals(ElementParameterParser.getValue(node,"__INCLUDEHEADER__"));

            boolean isInRowMode = ("true").equals(ElementParameterParser.getValue(node,"__ROW_MODE__"));

            boolean split = ("true").equals(ElementParameterParser.getValue(node, "__SPLIT__"));

            boolean flushOnRow = ("true").equals(ElementParameterParser.getValue(node, "__FLUSHONROW__"));
            String flushMod = ElementParameterParser.getValue(node, "__FLUSHONROW_NUM__");

            String advancedSeparatorStr = ElementParameterParser.getValue(node, "__ADVANCED_SEPARATOR__");
            boolean advancedSeparator = (advancedSeparatorStr!=null&&!("").equals(advancedSeparatorStr))?("true").equals(advancedSeparatorStr):false;
            String thousandsSeparator = ElementParameterParser.getValueWithJavaType(node, "__THOUSANDS_SEPARATOR__", JavaTypesManager.CHARACTER);
            String decimalSeparator = ElementParameterParser.getValueWithJavaType(node, "__DECIMAL_SEPARATOR__", JavaTypesManager.CHARACTER);

            String parallelize = ElementParameterParser.getValue(node,"__PARALLELIZE__");
            boolean isParallelize = (parallelize!=null&&!("").equals(parallelize))?("true").equals(parallelize):false;

            boolean compress = ("true").equals(ElementParameterParser.getValue(node,"__COMPRESS__"));

            boolean hasDynamic = metadata.isDynamicSchema();

            List< ? extends IConnection> conns = node.getIncomingConnections();
            for (IConnection conn : conns) {
                if (conn.getLineStyle().hasConnectionCategory(IConnectionCategory.DATA)) {
                    List<IMetadataColumn> columns = metadata.getListColumns();
                    int sizeColumns = columns.size();
                    
    stringBuffer.append(TEXT_3);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_4);
    
                    if(isIncludeHeader && hasDynamic){
                        if(codeGenArgument.getIsRunInMultiThread()){
                
    stringBuffer.append(TEXT_5);
    
                        }
                        if (((AbstractNode)node).getParallelIterator() != null) {
                
    stringBuffer.append(TEXT_6);
    stringBuffer.append(((AbstractNode)node).getParallelIterator());
    stringBuffer.append(TEXT_7);
    
                        }
                        if (isParallelize) {
                
    stringBuffer.append(TEXT_8);
    
                        }
                        if(!split && compress && !isAppend){
                        
    stringBuffer.append(TEXT_9);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_10);
    if(!useStream){
    stringBuffer.append(TEXT_11);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_12);
    }
    stringBuffer.append(TEXT_13);
    
                        }else{
                    
    stringBuffer.append(TEXT_14);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_15);
    if(!useStream){
    stringBuffer.append(TEXT_16);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_17);
    }
    stringBuffer.append(TEXT_18);
    
                        }
                        for (int i = 0; i < sizeColumns; i++) {
                            IMetadataColumn column = columns.get(i);
                            if(sizeColumns> schemaOptNum){
                                if(i%schemaOptNum==0){
                                
    stringBuffer.append(TEXT_19);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_20);
    stringBuffer.append(i/schemaOptNum);
    stringBuffer.append(TEXT_21);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_22);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_23);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_24);
    
                                }
                            }else{//AA
                            if(!("id_Dynamic".equals(column.getTalendType()))) {
                         
    stringBuffer.append(TEXT_25);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_26);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_27);
    
                            }else{
                         
    stringBuffer.append(TEXT_28);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_29);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_30);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_31);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_32);
    
                            }
                            if(i != sizeColumns - 1) {
                         
    stringBuffer.append(TEXT_33);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_34);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_35);
    
                            }
                            }//AA
                        }
                        
    stringBuffer.append(TEXT_36);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_37);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_38);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_39);
    
                        if (isParallelize) {
                
    stringBuffer.append(TEXT_40);
    
                        }
                        if (((AbstractNode)node).getParallelIterator() != null) {
                
    stringBuffer.append(TEXT_41);
    
                        }
                        if(codeGenArgument.getIsRunInMultiThread()){
                
    stringBuffer.append(TEXT_42);
    
                        }
                
    
                    }
                    for (int i = 0; i < sizeColumns; i++) {

                        IMetadataColumn column = columns.get(i);
                        JavaType javaType = JavaTypesManager.getJavaTypeFromId(column.getTalendType());
                        boolean isPrimitive = JavaTypesManager.isJavaPrimitiveType( javaType, column.isNullable());
                        if(sizeColumns> schemaOptNum){
                            if(i%schemaOptNum==0){

    stringBuffer.append(TEXT_43);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_44);
    stringBuffer.append(i/schemaOptNum);
    stringBuffer.append(TEXT_45);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_46);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_47);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_48);
    
                            }
                        }else{//BB
                        if(!isPrimitive) {
                            
    stringBuffer.append(TEXT_49);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_50);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_51);
    
                        }
                        if(column.getTalendType().equals("id_Dynamic")){
                            dynamic_column_index = i;
                            if(advancedSeparator){

    stringBuffer.append(TEXT_52);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_53);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_54);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_55);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_56);
    stringBuffer.append( thousandsSeparator );
    stringBuffer.append(TEXT_57);
    stringBuffer.append( decimalSeparator );
    stringBuffer.append(TEXT_58);
    
							}else{
    stringBuffer.append(TEXT_59);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_60);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_61);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_62);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_63);
    }
                        }else{
                        
    stringBuffer.append(TEXT_64);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_65);
    
                            String pattern = column.getPattern() == null || column.getPattern().trim().length() == 0 ? null : column.getPattern();
                            if (javaType == JavaTypesManager.DATE && pattern != null && pattern.trim().length() != 0) {
                            
    stringBuffer.append(TEXT_66);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_67);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_68);
    stringBuffer.append( pattern );
    stringBuffer.append(TEXT_69);
    
                            } else if(advancedSeparator && JavaTypesManager.isNumberType(javaType, column.isNullable())) {
                            
     if(javaType == JavaTypesManager.BIGDECIMAL) {
    stringBuffer.append(TEXT_70);
    stringBuffer.append(column.getPrecision() == null? conn.getName() + "." + column.getLabel() : conn.getName() + "." + column.getLabel() + ".setScale(" + column.getPrecision() + ", java.math.RoundingMode.HALF_UP)" );
    stringBuffer.append(TEXT_71);
    stringBuffer.append( thousandsSeparator );
    stringBuffer.append(TEXT_72);
    stringBuffer.append( decimalSeparator );
    stringBuffer.append(TEXT_73);
     } else { 
    stringBuffer.append(TEXT_74);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_75);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_76);
    stringBuffer.append( thousandsSeparator );
    stringBuffer.append(TEXT_77);
    stringBuffer.append( decimalSeparator );
    stringBuffer.append(TEXT_78);
     } 
    
                            } else if(javaType == JavaTypesManager.BIGDECIMAL){
                            
    stringBuffer.append(TEXT_79);
    stringBuffer.append(column.getPrecision() == null? conn.getName() + "." + column.getLabel() : conn.getName() + "." + column.getLabel() + ".setScale(" + column.getPrecision() + ", java.math.RoundingMode.HALF_UP)" );
    stringBuffer.append(TEXT_80);
    
                            } else if(javaType == JavaTypesManager.BYTE_ARRAY){
                            
    stringBuffer.append(TEXT_81);
    stringBuffer.append(encoding );
    stringBuffer.append(TEXT_82);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_83);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_84);
    
                            } else {
                            
    stringBuffer.append(TEXT_85);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_86);
    stringBuffer.append(column.getLabel() );
    
                            }
                        
    stringBuffer.append(TEXT_87);
    
                        }
                        if(!isPrimitive) {
                            
    stringBuffer.append(TEXT_88);
    
                        }
                        if(i != sizeColumns - 1) {
                            
    stringBuffer.append(TEXT_89);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_90);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_91);
    
                        }
                        }//BB
                    }
                    
    stringBuffer.append(TEXT_92);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_93);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_94);
    
                        if(codeGenArgument.getIsRunInMultiThread()){
                    
    stringBuffer.append(TEXT_95);
    
                        }
                        if (((AbstractNode)node).getParallelIterator() != null) {
                    
    stringBuffer.append(TEXT_96);
    stringBuffer.append(((AbstractNode)node).getParallelIterator());
    stringBuffer.append(TEXT_97);
    
                        }
                        if (isParallelize) {
                    
    stringBuffer.append(TEXT_98);
    
                        }
                    
    stringBuffer.append(TEXT_99);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_100);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_101);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_102);
    
                    // add a prerequisite useStream to support output stream feature:8873
                    if(!useStream && split){
                        
    stringBuffer.append(TEXT_103);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_104);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_105);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_106);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_107);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_108);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_109);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_110);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_111);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_112);
    if(!isAppend) {
    stringBuffer.append(TEXT_113);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_114);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_115);
    }
    stringBuffer.append(TEXT_116);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_117);
    stringBuffer.append(isInRowMode?"routines.system.BufferedOutput":"java.io.BufferedWriter");
    stringBuffer.append(TEXT_118);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_119);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_120);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_121);
    stringBuffer.append( isAppend);
    stringBuffer.append(TEXT_122);
    stringBuffer.append( encoding);
    stringBuffer.append(TEXT_123);
    
                            if(isIncludeHeader){
                                
    stringBuffer.append(TEXT_124);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_125);
    
                                    //List<IMetadataColumn> columns = metadata.getListColumns();
                                    //int sizeColumns = columns.size();
                                    for (int i = 0; i < sizeColumns; i++) {
                                        IMetadataColumn column = columns.get(i);
                                        if(sizeColumns> schemaOptNum){
                                            if(i%schemaOptNum==0){

    stringBuffer.append(TEXT_126);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_127);
    stringBuffer.append(i/schemaOptNum);
    stringBuffer.append(TEXT_128);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_129);
    stringBuffer.append(cid );
    if(hasDynamic){
    stringBuffer.append(TEXT_130);
    stringBuffer.append(conn.getName() );
    }
    stringBuffer.append(TEXT_131);
    
                                            }
                                        }else{//CC
                                        if(!("id_Dynamic".equals(column.getTalendType()))) {
                                        
    stringBuffer.append(TEXT_132);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_133);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_134);
    
                                        }else{
                                        
    stringBuffer.append(TEXT_135);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_136);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_137);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_138);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_139);
    
                                        }
                                        if(i != sizeColumns - 1) {
                                            
    stringBuffer.append(TEXT_140);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_141);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_142);
    
                                        }
                                        }//CC
                                    }
                                    
    stringBuffer.append(TEXT_143);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_144);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_145);
    
                            }
                            
    stringBuffer.append(TEXT_146);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_147);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_148);
    
                            if(flushOnRow) {
                                
    stringBuffer.append(TEXT_149);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_150);
    stringBuffer.append(flushMod );
    stringBuffer.append(TEXT_151);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_152);
    
                            }
                            
    stringBuffer.append(TEXT_153);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_154);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_155);
    
                            if(flushOnRow) {
                                
    stringBuffer.append(TEXT_156);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_157);
    stringBuffer.append(flushMod );
    stringBuffer.append(TEXT_158);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_159);
    
                            }
                            
    stringBuffer.append(TEXT_160);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_161);
    
                    } else {
                        
    stringBuffer.append(TEXT_162);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_163);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_164);
    
                        if(flushOnRow) {
                            
    stringBuffer.append(TEXT_165);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_166);
    stringBuffer.append(flushMod );
    stringBuffer.append(TEXT_167);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_168);
    
                        }
                        
    
                    }
                    
    if(isLog4jEnabled){
    stringBuffer.append(TEXT_169);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_170);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_171);
    }
    stringBuffer.append(TEXT_172);
    
                        if (isParallelize) {
                    
    stringBuffer.append(TEXT_173);
    
                        }
                        if (((AbstractNode)node).getParallelIterator() != null) {
                    
    stringBuffer.append(TEXT_174);
    
                        }
                        if(codeGenArgument.getIsRunInMultiThread()){
                    
    stringBuffer.append(TEXT_175);
    
                        }
                    
    stringBuffer.append(TEXT_176);
    
                }
            }
        }
    }
    
    stringBuffer.append(TEXT_177);
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}else{//the following is the tFileOutputCSV component
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    stringBuffer.append(TEXT_178);
    

    List<IMetadataTable> metadatas = node.getMetadataList();
    if ((metadatas!=null)&&(metadatas.size()>0)) {
        IMetadataTable metadata = metadatas.get(0);
        if (metadata!=null) {
            String encoding = ElementParameterParser.getValue(node,"__ENCODING__");
            String delim = ElementParameterParser.getValue(node, "__FIELDSEPARATOR__");
            boolean isIncludeHeader = ("true").equals(ElementParameterParser.getValue(node,"__INCLUDEHEADER__"));
            boolean isAppend = ("true").equals(ElementParameterParser.getValue(node,"__APPEND__"));

            boolean split = ("true").equals(ElementParameterParser.getValue(node, "__SPLIT__"));

            boolean isInRowMode = ("true").equals(ElementParameterParser.getValue(node,"__ROW_MODE__"));

            boolean flushOnRow = ("true").equals(ElementParameterParser.getValue(node, "__FLUSHONROW__"));
            String flushMod = ElementParameterParser.getValue(node, "__FLUSHONROW_NUM__");

            String advancedSeparatorStr = ElementParameterParser.getValue(node, "__ADVANCED_SEPARATOR__");
            boolean advancedSeparator = (advancedSeparatorStr!=null&&!("").equals(advancedSeparatorStr))?("true").equals(advancedSeparatorStr):false;
            String thousandsSeparator = ElementParameterParser.getValueWithJavaType(node, "__THOUSANDS_SEPARATOR__", JavaTypesManager.CHARACTER);
            String decimalSeparator = ElementParameterParser.getValueWithJavaType(node, "__DECIMAL_SEPARATOR__", JavaTypesManager.CHARACTER);

            String parallelize = ElementParameterParser.getValue(node,"__PARALLELIZE__");
            boolean isParallelize = (parallelize!=null&&!("").equals(parallelize))?("true").equals(parallelize):false;

            List< ? extends IConnection> conns = node.getIncomingConnections();

            boolean compress = ("true").equals(ElementParameterParser.getValue(node,"__COMPRESS__"));

            boolean useOSLineSeparator = ("true").equals(ElementParameterParser.getValue(node,"__OS_LINE_SEPARATOR_AS_ROW_SEPARATOR__"));

            boolean hasDynamic = metadata.isDynamicSchema();
            IMetadataColumn dynamicCol = metadata.getDynamicColumn();
            if(hasDynamic){
                
    stringBuffer.append(TEXT_179);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_180);
    
            }
            if(conns!=null){
                if (conns.size()>0){
                    IConnection conn =conns.get(0);
                    if (conn.getLineStyle().hasConnectionCategory(IConnectionCategory.DATA)) {
                        List<IMetadataColumn> columns = metadata.getListColumns();
                        int sizeColumns = columns.size();
                        if(isIncludeHeader && hasDynamic){

                            if(codeGenArgument.getIsRunInMultiThread()){
                            
    stringBuffer.append(TEXT_181);
    
                            }
                            if (((AbstractNode)node).getParallelIterator() != null) {
                            
    stringBuffer.append(TEXT_182);
    stringBuffer.append(((AbstractNode)node).getParallelIterator());
    stringBuffer.append(TEXT_183);
    
                            }
                            if (isParallelize) {
                            
    stringBuffer.append(TEXT_184);
    
                            }
                            if(!split && compress && !isAppend){
                            
    stringBuffer.append(TEXT_185);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_186);
    if(!useStream){
    stringBuffer.append(TEXT_187);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_188);
    }
    stringBuffer.append(TEXT_189);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_190);
    stringBuffer.append(sizeColumns);
    stringBuffer.append(TEXT_191);
    stringBuffer.append(conn.getName());
    stringBuffer.append(TEXT_192);
    stringBuffer.append(dynamicCol.getLabel());
    stringBuffer.append(TEXT_193);
    
                            }else{
                        
    stringBuffer.append(TEXT_194);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_195);
    if(!useStream){
    stringBuffer.append(TEXT_196);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_197);
    }
    stringBuffer.append(TEXT_198);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_199);
    stringBuffer.append(sizeColumns);
    stringBuffer.append(TEXT_200);
    stringBuffer.append(conn.getName());
    stringBuffer.append(TEXT_201);
    stringBuffer.append(dynamicCol.getLabel());
    stringBuffer.append(TEXT_202);
    
                            }
                            for (int i = 0; i < sizeColumns; i++) {
                                IMetadataColumn column = columns.get(i);
                                if(("id_Dynamic").equals(column.getTalendType())) {
                                    
    stringBuffer.append(TEXT_203);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_204);
    stringBuffer.append(conn.getName());
    stringBuffer.append(TEXT_205);
    stringBuffer.append(column.getLabel());
    stringBuffer.append(TEXT_206);
    
                                }
                                if(sizeColumns> schemaOptNum){
                                    if(i%schemaOptNum==0){

    stringBuffer.append(TEXT_207);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_208);
    stringBuffer.append(i/schemaOptNum);
    stringBuffer.append(TEXT_209);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_210);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_211);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_212);
    
                                    }
                                }else{//DD
                                if(!("id_Dynamic".equals(column.getTalendType()))) {
                                    if(i>dynamic_column_index&& dynamic_column_index != -1){
                             
    stringBuffer.append(TEXT_213);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_214);
    stringBuffer.append(i-1);
    stringBuffer.append(TEXT_215);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_216);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_217);
    
                                    }else{
                             
    stringBuffer.append(TEXT_218);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_219);
    stringBuffer.append(i);
    stringBuffer.append(TEXT_220);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_221);
    
                                    }
                                }else{
                                dynamic_column_index = i;
                             
    stringBuffer.append(TEXT_222);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_223);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_224);
    stringBuffer.append(i);
    stringBuffer.append(TEXT_225);
    stringBuffer.append(conn.getName());
    stringBuffer.append(TEXT_226);
    stringBuffer.append(column.getLabel());
    stringBuffer.append(TEXT_227);
    
                                }
                                }//DD
                            }
                            
    stringBuffer.append(TEXT_228);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_229);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_230);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_231);
    if(isInRowMode){
    stringBuffer.append(TEXT_232);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_233);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_234);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_235);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_236);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_237);
    }
    stringBuffer.append(TEXT_238);
    
                            if (isParallelize) {
                        
    stringBuffer.append(TEXT_239);
    
                            }
                            if (((AbstractNode)node).getParallelIterator() != null) {
                        
    stringBuffer.append(TEXT_240);
    
                            }
                            if(codeGenArgument.getIsRunInMultiThread()){
                        
    stringBuffer.append(TEXT_241);
    
                            }
                        
    stringBuffer.append(TEXT_242);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_243);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_244);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_245);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_246);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_247);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_248);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_249);
    
                        }
                        
    stringBuffer.append(TEXT_250);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_251);
    stringBuffer.append(sizeColumns);
    stringBuffer.append(hasDynamic?"+"+conn.getName()+".":"" );
    stringBuffer.append(dynamicCol==null?"":dynamicCol.getLabel()+".getColumnCount()-1" );
    stringBuffer.append(TEXT_252);
    
                        if(hasDynamic){
                        
    stringBuffer.append(TEXT_253);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_254);
    
                        }
                        for (int i = 0; i < sizeColumns; i++) {
                            IMetadataColumn column = columns.get(i);
                            JavaType javaType = JavaTypesManager.getJavaTypeFromId(column.getTalendType());
                            String pattern = column.getPattern() == null || column.getPattern().trim().length() == 0 ? null : column.getPattern();
                            boolean isPrimitive = JavaTypesManager.isJavaPrimitiveType( column.getTalendType(), column.isNullable());
                            if(("id_Dynamic").equals(column.getTalendType())) {
                                
    stringBuffer.append(TEXT_255);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_256);
    stringBuffer.append(conn.getName());
    stringBuffer.append(TEXT_257);
    stringBuffer.append(dynamicCol.getLabel());
    stringBuffer.append(TEXT_258);
    
                            }
                            if(sizeColumns> schemaOptNum){
                                if(i%schemaOptNum==0){

    stringBuffer.append(TEXT_259);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_260);
    stringBuffer.append(i/schemaOptNum);
    stringBuffer.append(TEXT_261);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_262);
    stringBuffer.append(cid);
    if(hasDynamic){
    stringBuffer.append(TEXT_263);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_264);
    }
    stringBuffer.append(TEXT_265);
    
                                }
                            }else{//EE
                            if(("id_Dynamic").equals(column.getTalendType())) {
                                dynamic_column_index=i;
                            
    stringBuffer.append(TEXT_266);
    stringBuffer.append(conn.getName());
    stringBuffer.append(TEXT_267);
    stringBuffer.append(column.getLabel());
    stringBuffer.append(TEXT_268);
    stringBuffer.append(conn.getName());
    stringBuffer.append(TEXT_269);
    stringBuffer.append(column.getLabel());
    stringBuffer.append(TEXT_270);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_271);
    stringBuffer.append(dynamic_column_index);
    stringBuffer.append(TEXT_272);
    
                                   if(applyNA4Null){
                                        
    stringBuffer.append(TEXT_273);
    stringBuffer.append( str4Nil );
    stringBuffer.append(TEXT_274);
    
                                   }else{
                                        
    stringBuffer.append(TEXT_275);
    
                                   }
                                 
    stringBuffer.append(TEXT_276);
    
                            }else{
                                if(i>dynamic_column_index && dynamic_column_index !=-1){
                            
    stringBuffer.append(TEXT_277);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_278);
    stringBuffer.append(i-1);
    stringBuffer.append(TEXT_279);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_280);
    stringBuffer.append(isPrimitive? "":conn.getName()+"."+column.getLabel()+ " == null ? null : ");
    
                                }else{
                            
    stringBuffer.append(TEXT_281);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_282);
    stringBuffer.append(i);
    stringBuffer.append(TEXT_283);
    stringBuffer.append(isPrimitive? "":conn.getName()+"."+column.getLabel()+ " == null ? null : ");
    
                                }
                                if(javaType == JavaTypesManager.STRING ){
                            
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_284);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_285);
    
                                }else if(javaType == JavaTypesManager.DATE && pattern != null){
                            
    stringBuffer.append(TEXT_286);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_287);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_288);
    stringBuffer.append( pattern );
    stringBuffer.append(TEXT_289);
    
                                }else if(javaType == JavaTypesManager.BYTE_ARRAY){
                            
    stringBuffer.append(TEXT_290);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_291);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_292);
    
                                } else if(advancedSeparator && JavaTypesManager.isNumberType(javaType, column.isNullable())) {
                                    if(javaType == JavaTypesManager.BIGDECIMAL) {
    stringBuffer.append(TEXT_293);
    stringBuffer.append(column.getPrecision() == null? conn.getName() + "." + column.getLabel() : conn.getName() + "." + column.getLabel() + ".setScale(" + column.getPrecision() + ", java.math.RoundingMode.HALF_UP)" );
    stringBuffer.append(TEXT_294);
    stringBuffer.append( thousandsSeparator );
    stringBuffer.append(TEXT_295);
    stringBuffer.append( decimalSeparator );
    stringBuffer.append(TEXT_296);
          } else { 
    stringBuffer.append(TEXT_297);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_298);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_299);
    stringBuffer.append( thousandsSeparator );
    stringBuffer.append(TEXT_300);
    stringBuffer.append( decimalSeparator );
    stringBuffer.append(TEXT_301);
          }
                                } else if (javaType == JavaTypesManager.BIGDECIMAL) {
                            
    stringBuffer.append(column.getPrecision() == null? conn.getName() + "." + column.getLabel() : conn.getName() + "." + column.getLabel() + ".setScale(" + column.getPrecision() + ", java.math.RoundingMode.HALF_UP)" );
    stringBuffer.append(TEXT_302);
    
                                } else{
                            
    stringBuffer.append(TEXT_303);
    stringBuffer.append(conn.getName() );
    stringBuffer.append(TEXT_304);
    stringBuffer.append(column.getLabel() );
    stringBuffer.append(TEXT_305);
    
                                }
                            }
                            }//EE
                        }

                          if(codeGenArgument.getIsRunInMultiThread()){

    stringBuffer.append(TEXT_306);
    
                        }
                        if (((AbstractNode)node).getParallelIterator() != null) {

    stringBuffer.append(TEXT_307);
    stringBuffer.append(((AbstractNode)node).getParallelIterator());
    stringBuffer.append(TEXT_308);
    
                        }
                        if (isParallelize) {

    stringBuffer.append(TEXT_309);
    
                        }

    stringBuffer.append(TEXT_310);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_311);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_312);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_313);
    
                        if(!useStream && split){
                            
    stringBuffer.append(TEXT_314);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_315);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_316);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_317);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_318);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_319);
    if(!isAppend) {
    stringBuffer.append(TEXT_320);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_321);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_322);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_323);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_324);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_325);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_326);
    }
    stringBuffer.append(TEXT_327);
    if(isInRowMode){
    stringBuffer.append(TEXT_328);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_329);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_330);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_331);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_332);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_333);
    stringBuffer.append(isAppend);
    stringBuffer.append(TEXT_334);
    stringBuffer.append(encoding);
    stringBuffer.append(TEXT_335);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_336);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_337);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_338);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_339);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_340);
    }else{
    stringBuffer.append(TEXT_341);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_342);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_343);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_344);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_345);
    stringBuffer.append(isAppend);
    stringBuffer.append(TEXT_346);
    stringBuffer.append(encoding);
    stringBuffer.append(TEXT_347);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_348);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_349);
    }
    stringBuffer.append(TEXT_350);
    
                                if(!useOSLineSeparator) {
                                
    stringBuffer.append(TEXT_351);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_352);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_353);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_354);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_355);
    
                                } else {
                                
    stringBuffer.append(TEXT_356);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_357);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_358);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_359);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_360);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_361);
    
                                }
                                
    stringBuffer.append(TEXT_362);
    
                                if(isIncludeHeader && !isAppend){
                                    
    stringBuffer.append(TEXT_363);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_364);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_365);
    if(isInRowMode){
    stringBuffer.append(TEXT_366);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_367);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_368);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_369);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_370);
    }
                                }
                                if(isIncludeHeader && isAppend){
                                    
    stringBuffer.append(TEXT_371);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_372);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_373);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_374);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_375);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_376);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_377);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_378);
    if(isInRowMode){
    stringBuffer.append(TEXT_379);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_380);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_381);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_382);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_383);
    }
    stringBuffer.append(TEXT_384);
    
                                }
                                
    stringBuffer.append(TEXT_385);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_386);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_387);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_388);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_389);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_390);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_391);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_392);
    if(isInRowMode){
    stringBuffer.append(TEXT_393);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_394);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_395);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_396);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_397);
    }
                                if(flushOnRow) {
                                    
    stringBuffer.append(TEXT_398);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_399);
    stringBuffer.append(flushMod );
    stringBuffer.append(TEXT_400);
    if(isInRowMode){
    stringBuffer.append(TEXT_401);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_402);
    }else{
    stringBuffer.append(TEXT_403);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_404);
    }
    stringBuffer.append(TEXT_405);
    
                                }
                                
    stringBuffer.append(TEXT_406);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_407);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_408);
    if(isInRowMode){
    stringBuffer.append(TEXT_409);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_410);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_411);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_412);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_413);
    }
                                if(flushOnRow) {
                                    
    stringBuffer.append(TEXT_414);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_415);
    stringBuffer.append(flushMod );
    stringBuffer.append(TEXT_416);
    if(isInRowMode){
    stringBuffer.append(TEXT_417);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_418);
    }else{
    stringBuffer.append(TEXT_419);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_420);
    }
    stringBuffer.append(TEXT_421);
    
                                }
                                
    stringBuffer.append(TEXT_422);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_423);
    
                        }else{
                            
    
                               if(applyNA4Null){
                                    
    stringBuffer.append(TEXT_424);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_425);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_426);
    stringBuffer.append( str4Nil );
    stringBuffer.append(TEXT_427);
    
                               }else{
                                    
    stringBuffer.append(TEXT_428);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_429);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_430);
    
                               }
                             
    if(isInRowMode){
    stringBuffer.append(TEXT_431);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_432);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_433);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_434);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_435);
    }
                            if(flushOnRow) {
                                
    stringBuffer.append(TEXT_436);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_437);
    stringBuffer.append(flushMod );
    stringBuffer.append(TEXT_438);
    if(isInRowMode){
    stringBuffer.append(TEXT_439);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_440);
    }else{
    stringBuffer.append(TEXT_441);
    stringBuffer.append(cid );
    stringBuffer.append(TEXT_442);
    }
    stringBuffer.append(TEXT_443);
    
                            }
                            
    

                        }
                        
    if(isLog4jEnabled){
    stringBuffer.append(TEXT_444);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_445);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_446);
    }
    stringBuffer.append(TEXT_447);
    
                        if ( isParallelize) {

    stringBuffer.append(TEXT_448);
    
                        }
                        if (((AbstractNode)node).getParallelIterator() != null) {

    stringBuffer.append(TEXT_449);
    
                        }
                        if(codeGenArgument.getIsRunInMultiThread()){

    stringBuffer.append(TEXT_450);
    
                        }

    stringBuffer.append(TEXT_451);
    
                    }

                }
            }

        }

    }
    
    stringBuffer.append(TEXT_452);
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

    stringBuffer.append(TEXT_453);
    return stringBuffer.toString();
  }
}
