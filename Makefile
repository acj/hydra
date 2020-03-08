all: parser src jar doc

src:
	javac -d build -nowarn -cp src src/backend/h2PFoundation/*.java \
		src/backend/h2PVisitors/*.java 
		src/backend/h2PNodes/*.java \
		src/Main.java \
		src/frontend/umlModel/*.java \
		src/frontend/xmi2hil/*.java \
		src/frontend/xdeXmiParser/*.java \
		src/frontend/rhapsodyXmiParser/*.java \
		src/frontend/rsaXmiParser/*.java

parser:
	cd ./src/backend/h2PParser && ./generate-parser.sh && cd ../../../
	javac -d build -nowarn -cp src src/backend/h2PParser/*.java

jar:
	cd build && jar -cf ../hydra.jar frontend backend Main.class && cd ..

doc:
	javadoc -doctitle "Hydra class documentation" -windowtitle "Hydra class documentation" -classpath src -protected -d docs/classes frontend backend.h2PFoundation backend.h2PNodes backend.h2PParser backend.h2PVisitors backend.hil2Promela frontend.rhapsodyXmiParser frontend.rsaXmiParser frontend.umlModel frontend.xdeXmiParser frontend.xmi2hil
	mkdir -p docs/grammars
	jjdoc -ONE_TABLE=true -OUTPUT_FILE=docs/grammars/HILParser.html src/backend/h2PParser/HILParser.jj
	jjdoc -ONE_TABLE=true -OUTPUT_FILE=docs/grammars/UMLExpr.html src/backend/h2PParser/UMLExpr.jj