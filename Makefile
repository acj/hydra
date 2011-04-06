all: parser src jar doc

src:
	javac -d build -nowarn -cp src src/h2PFoundation/*.java \
		src/h2PVisitors/*.java src/promelaParser/*.java \
		src/xmi2hil/*.java \
		src/h2PNodes/*.java \
		src/MainDriver.java \
		src/umlModel/*.java \
		src/xmiParser/*.java

parser:
	cd ./src/h2PParser && ./generate-parser.sh && cd ../../

jar:
	cd build && jar -cfe ../hydra.jar MainDriver h2PFoundation h2PVisitors xmi2hil h2PNodes umlModel xmiParser MainDriver.class && cd ..

doc:
	javadoc -doctitle "Hydra class documentation" -windowtitle "Hydra class documentation" -classpath src -protected -d docs/classes h2PFoundation h2PVisitors h2PNodes umlModel xmiParser
	jjdoc -ONE_TABLE=true -OUTPUT_FILE=docs/grammars/HILParser.html src/h2PVisitors/Parser/HILParser.jj
	jjdoc -ONE_TABLE=true -OUTPUT_FILE=docs/grammars/UMLExpr.html src/h2PVisitors/Parser/UMLExpr.jj