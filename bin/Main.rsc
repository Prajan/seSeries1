module Main

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core; 
import lang::java::m3::Core;
import util::Math;
import Number;
import List;
import IO;


import LinesOfCodeCalculator;
import CyclomaticComplexity;

public loc HelloWorldLoc = |project://HelloWorld|;
public loc smallsqlLoc = |project://smallsql|;

public void startAnalysis(loc project){
	println("Analysis started. Please wait..");
	reportProjectMetrics(project);

}

public void reportProjectMetrics(loc project){
	
	int totalLoc = calculateProjectLoc(project);
	ast = createAstsFromEclipseProject(project, false);
	
	// report on CC
	int lowRiskLoc = 0;
	int modRiskLoc = 0;
	int highRiskLoc = 0;
	int veryHighRiskLoc = 0;
	
	for(cc <- getComplexityPerUnit(ast)){
		if(cc.complexity <= 10) { lowRiskLoc += cc.lofc; continue; }
		if(cc.complexity > 10 && cc.complexity <= 20) { modRiskLoc += cc.lofc; continue; }
		if(cc.complexity > 20 && cc.complexity <= 50) { highRiskLoc += cc.lofc; continue; }
		veryHighRiskLoc += cc.lofc;
	}
	
	int lowRiskRatio = round((toReal(lowRiskLoc) / totalLoc) * 100);
	int modRiskRatio = round((toReal(modRiskLoc) / totalLoc) * 100);
	int highRiskRatio = round((toReal(highRiskLoc) / totalLoc) * 100);
	int veryHighRiskRatio = round((toReal(veryHighRiskLoc) / totalLoc) * 100);
	
	println("Risk evaluation:
	'	Percentage of low risk:		<lowRiskRatio>%
	'	Percentage of moderate risk:	<modRiskRatio>%
	'	Percentage of high risk:	<highRiskRatio>%
	'	Percentage of very high risk:	<veryHighRiskRatio>%
	'	This gives the project a \'<determineCyclComRanking(lowRiskRatio, modRiskRatio, highRiskRatio, veryHighRiskRatio)>\' for Cyclomatic Complexity.");
}

public str determineCyclComRanking(int low, int moderate, int high, int veryHigh){
	if(moderate <= 25 && high == 0 && veryHigh == 0)
		return "++";
	if(moderate <= 30 && high <= 5 && veryHigh == 0)
		return "+";
	if(moderate <= 40 && high <= 10 && veryHigh == 0)
		return "o";
	if(moderate <= 50 && high <= 15 && veryHigh <= 5)
		return "-";
	return "--";
}