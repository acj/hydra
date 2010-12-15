all: parser doc
	javac -nowarn -cp src src/h2PFoundation/*.java \
		src/h2PVisitors/*.java src/promelaParser/*.java \
		src/xmi2hil/*.java \
		src/h2PNodes/*.java \
		src/MainDriver.java \
		src/umlModel/*.java \
		src/xmiParser/*.java

parser:
	cd ./src/h2PVisitors/Parser && ./generate-parser.sh > /dev/null && cd ../../../

doc:
	javadoc -classpath src -protected -d docs/classes h2PFoundation h2PVisitors promelaParser h2PNodes umlModel xmiParser
	jjdoc -ONE_TABLE=true -OUTPUT_FILE=docs/grammars/HILParser.html src/h2PVisitors/Parser/HILParser.jj
	jjdoc -ONE_TABLE=true -OUTPUT_FILE=docs/grammars/UMLExpr.html src/h2PVisitors/Parser/UMLExpr.jj