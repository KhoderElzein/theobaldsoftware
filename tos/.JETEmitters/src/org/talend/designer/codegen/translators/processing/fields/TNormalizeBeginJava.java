package org.talend.designer.codegen.translators.processing.fields;

import org.talend.core.model.process.INode;
import org.talend.designer.codegen.config.CodeGeneratorArgument;
import org.talend.core.model.process.ElementParameterParser;
import org.talend.core.model.metadata.IMetadataTable;
import org.talend.core.model.metadata.IMetadataColumn;
import java.util.List;

public class TNormalizeBeginJava
{
  protected static String nl;
  public static synchronized TNormalizeBeginJava create(String lineSeparator)
  {
    nl = lineSeparator;
    TNormalizeBeginJava result = new TNormalizeBeginJava();
    nl = null;
    return result;
  }

  public final String NL = nl == null ? (System.getProperties().getProperty("line.separator")) : nl;
  protected final String TEXT_1 = "";
  protected final String TEXT_2 = NL + "    int nb_line_";
  protected final String TEXT_3 = " = 0;";
  protected final String TEXT_4 = NL + "        String tmp_";
  protected final String TEXT_5 = " = null;" + NL + "        StringBuilder currentRecord_";
  protected final String TEXT_6 = " = null;" + NL + "        String [] normalizeRecord_";
  protected final String TEXT_7 = " = null;" + NL + "        java.util.Set<String> recordSet_";
  protected final String TEXT_8 = " = new java.util.HashSet<String>();" + NL + "        " + NL + "\t\t\t\tif ( ((String)";
  protected final String TEXT_9 = ").length() == 0 ){" + NL + "\t\t\t\t\tthrow new IllegalArgumentException(\"Field Separator must be assigned a char.\"); " + NL + "\t\t\t\t}" + NL + "\t\t\t\t";
  protected final String TEXT_10 = NL + "\t\t\t\tif ( ((String)";
  protected final String TEXT_11 = ").length() == 0 ){" + NL + "\t\t\t\t\tthrow new IllegalArgumentException(\"Text enclosure must be assigned a char.\"); " + NL + "\t\t\t\t}" + NL + "\t\t\t\t";
  protected final String TEXT_12 = NL;

  public String generate(Object argument)
  {
    final StringBuffer stringBuffer = new StringBuffer();
    stringBuffer.append(TEXT_1);
    
	CodeGeneratorArgument codeGenArgument = (CodeGeneratorArgument) argument;
	INode node = (INode)codeGenArgument.getArgument();
	String cid = node.getUniqueName();
	String deduplicate = ElementParameterParser.getValue(node, "__DEDUPLICATE__");
	String delim = ElementParameterParser.getValue(node, "__ITEMSEPARATOR__");
	String textEnclosure = ElementParameterParser.getValue(node, "__TEXT_ENCLOSURE__");   
	boolean useCSV = ("true").equals(ElementParameterParser.getValue(node, "__CSV_OPTION__"));
	List<IMetadataColumn> metadataColumns = null;
	List<IMetadataTable> metadatas = node.getMetadataList();
	if (metadatas != null && metadatas.size() > 0) {
	    IMetadataTable metadata = metadatas.get(0);    
	    if (metadata!=null) {
	        metadataColumns = metadata.getListColumns();
	    }
	}

    stringBuffer.append(TEXT_2);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_3);
    
    if(metadataColumns != null && metadataColumns.size() > 0) {
        
    stringBuffer.append(TEXT_4);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_5);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_6);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_7);
    stringBuffer.append(cid);
    stringBuffer.append(TEXT_8);
    stringBuffer.append(delim);
    stringBuffer.append(TEXT_9);
    if(useCSV){
    stringBuffer.append(TEXT_10);
    stringBuffer.append(textEnclosure);
    stringBuffer.append(TEXT_11);
    }
    
    }

    stringBuffer.append(TEXT_12);
    return stringBuffer.toString();
  }
}
