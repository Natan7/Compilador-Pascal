java -jar ../../libs/jflex-1.6.1/lib/jflex-1.6.1.jar ../analisadores/lexer.jflex
java -jar ../../libs/java-cup-11b.jar -package compiler.generated -expect 10000 -destdir ../analisadores/ -parser Parser -symbols sym ../analisadores/syntatic.cup
