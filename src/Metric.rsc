module Metric

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import analysis::m3::metrics::LOC;
import List;
import IO;

public set[Declaration]  CreateAst(){
   return createAstsFromEclipseProject (|project://smallsql|, false);
   //println(ast);
 // visit(ast){
	//case method(_, str name,_,_,_): println(name);
	//}
}
 public void printTotalNmbOfMethods(){
    println("project smallsql has got a total of <totalMethods()> methods.");    
 }
 
 public int totalMethods() = 
 	size([e | e <- createM3FromEclipseProject(|project://smallsql|)@containment, /java\+method+/ := e.from.scheme]);
 	
 public int countTotalLoc(){
 	return countProjectTotalLoc(createM3FromEclipseProject(|project://smallsql|));
 }
 
 public int totalLines(){
    int lines = 0;
 for(e <- createM3FromEclipseProject(|project://smallsql|)){
    lines += size(readFile(e.from));
 }
 return lines;
 
 }
 
 