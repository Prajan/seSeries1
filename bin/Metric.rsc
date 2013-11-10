module Metric

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import List;
import IO;


 public void printTotalNmbOfMethods(){
    println("project smallsql has got a total of <totalMethods()> methods.");    
 }
 
 public int totalMethods() = 
 	size([e | e <- createM3FromEclipseProject(|project://smallsql|)@containment, /java\+method+/ := e.from.scheme]);