module Metric

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import analysis::m3::metrics::LOC;
import List;
import IO;



public set[Declaration]  CreateAst(){
   ast = createAstsFromEclipseProject (|project://smallsql|, false);
   visit(ast){
//	 case method(_, str name,_,_,_): println(name);
//  case package(_,str sour): println("------------" + sour);
case package(_,str sour): println("------------" + sour);
   }
}


public void getAllFiles(){
//  println (sourceFilesForProject(|project://smallsql/|));
  int totalFileLines = 0;
  int perFileLines = 0;
  for (e <- sourceFilesForProject(|project://smallsql/|)){  
    perFileLines = 0;
    totalFileLines += size(readFileLines(e));
    perFileLines += size(readFileLines(e));
    println("Totalline in <e> : <perFileLines>");
  }
  println("Total lines in project <totalFileLines>");
  
}


/*
q = {1,2,3};
for (e <- q){
  println("<e>");
};

v = {|project://smallsql/src/smallsql/database/a.java|,|project://smallsql/src/smallsql/database/2.java|,|project://smallsql/src/smallsql/database/Column.java|};
for (e <- v){
  println("<v>");
};


readFileLines(|project://smallsql/src/smallsql/database/Column.java|);
 size(readFileLines(|project://smallsql/src/smallsql/database/Column.java|));
*/


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
 
 