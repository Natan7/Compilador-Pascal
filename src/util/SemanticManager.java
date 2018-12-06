package util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class SemanticManager {

	private static SemanticManager instance = null;

	public static int lineError = 0; // ADICIONAR EM TODOS OS METODOS

	// Chave = nome; Valor = tipo de retorno
	HashMap<String, String> functions = new HashMap<String, String>();

	// Chave = nome; Valor = lista com os tipos dos parametros
	HashMap<String, ArrayList<String>> funcParams = new HashMap<String, ArrayList<String>>();

	// Chave = nome; Valor = lista com os tipos dos parametros
	HashMap<String, ArrayList<String>> procedures = new HashMap<String, ArrayList<String>>();

	// Todas as variáveis já declaradas no código; Chave = nome; Valor = tipo.
	HashMap<String, String> variables = new HashMap<String, String>();

	// HashMap<String, String> constants = new HashMap<String, String>();

	// Valores das variáveis; Chave = nome da variável; Valor = lista com todos
	// os valores assumidos pela mesma
	HashMap<String, ArrayList<String>> values = new HashMap<String, ArrayList<String>>();

	// Labels já declarados no código
	ArrayList<Integer> labels = new ArrayList<Integer>();

	// Tipos suportados pela linguagem
	ArrayList<String> types = new ArrayList<String>();

	// Todos os identificadores já declarados no código (nome de variável,
	// função, procedure, etc.)
	ArrayList<String> identifiers = new ArrayList<String>();

	// Guarda os tipos derivados de cada um
	ArrayList<String> integer, intSign, reals, strings, bool;

	private SemanticManager() {
		this.types = new ArrayList<String>(Arrays.asList("byte", "word",
				"cardinal", "shortint", "smallint", "integer", "longint",
				"real", "string", "char", "boolean"));
		this.integer = new ArrayList<String>(Arrays.asList("byte", "word",
				"cardinal", "shortint", "smallint", "integer", "longint"));
		this.reals = new ArrayList<String>(Arrays.asList("real"));
		this.strings = new ArrayList<String>(Arrays.asList("string", "char"));
		this.bool = new ArrayList<String>(Arrays.asList("boolean"));
	}

	public static SemanticManager getInstance() {
		if (instance == null) {
			instance = new SemanticManager();
		}
		return instance;
	}

	public static void setInstance(){
		instance = null;
	}



	public void addVariable(String identifier, String type, String value) {
		if (variables.containsKey(identifier)
				|| identifiers.contains(identifier)) {
			System.out.println("Duplicated identifier: " + identifier);
			System.exit(1);
		} else {
			identifiers.add(identifier);
			variables.put(identifier, null);
			if(type != null){
				if (!types.contains(type)) {
					System.out.println("Pascal does not support the type: " + type);
					System.exit(1);
				} else {
						variables.put(identifier, type);
						if (value != null){
							ArrayList<String> variableValues = values.get(identifier);
							if (variableValues == null) {
								variableValues = new ArrayList<String>();
							} else {
								variableValues.add(value);
							}
							values.put(identifier, variableValues);
						}
					}
			}
		}
	}

	public void addLabel(Integer label) {
		if (labels.contains(label)) {
			System.err.println("Label already declared: " + label + ". Error in line: " + lineError);
			System.exit(1);
		} else {
			labels.add(label);
		}
	}

	public void addIdentifier(String identifier) {
		if (identifiers.contains(identifier.toLowerCase())) {
			System.out.println("Duplicated identifier: " + identifier);
			System.exit(1);
		} else {
			identifiers.add(identifier);
		}
	}


	/* ---------- CHECK methods --------- */

	public boolean checkTypesHierarchy(String typeOfCalledMethod,
			String typeOfDefinition) {
		String typeOfCalledMethodTemp = typeOfCalledMethod.toLowerCase();
		String typeOfDefinitionTemp = typeOfDefinition.toLowerCase();

		if (integer.contains(typeOfCalledMethodTemp)
				&& integer.contains(typeOfDefinitionTemp)) {
			if (typeOfDefinitionTemp.equals("byte")
					&& typeOfCalledMethodTemp.equals("byte")) {
				return true;
			} else if (typeOfDefinitionTemp.equals("word")
					&& (typeOfCalledMethodTemp.equals("byte") || typeOfCalledMethodTemp
							.equals("word"))) {
				return true;
			} else if (typeOfDefinitionTemp.equals("cardinal")
					&& (typeOfCalledMethodTemp.equals("byte")
							|| typeOfCalledMethodTemp.equals("word") || typeOfCalledMethodTemp
								.equals("cardinal"))) {
				return true;
			} else if (typeOfDefinitionTemp.equals("shortint")
					&& typeOfCalledMethodTemp.equals("shortint")) {
				return true;
			} else if (typeOfDefinitionTemp.equals("smallint")
					&& (typeOfCalledMethodTemp.equals("shortint") || typeOfCalledMethodTemp
							.equals("smallint"))) {
				return true;
			} else if (typeOfDefinitionTemp.equals("integer")
					&& (typeOfCalledMethodTemp.equals("byte")
							|| typeOfCalledMethodTemp.equals("word")
							|| typeOfCalledMethodTemp.equals("cardinal")
							|| typeOfCalledMethodTemp.equals("shortint")
							|| typeOfCalledMethodTemp.equals("smallint") || typeOfCalledMethodTemp
								.equals("integer"))) {
				return true;
			} else if (typeOfDefinitionTemp.equals("longint")
					&& (typeOfCalledMethodTemp.equals("shortint")
							|| typeOfCalledMethodTemp.equals("smallint")
							|| typeOfCalledMethodTemp.equals("integer") || typeOfCalledMethodTemp
								.equals("longint"))) {
				return true;
			} else {
				System.out.println("Incompatible types: " + typeOfCalledMethod
						+ ", " + typeOfDefinition);
				return false;
			}
		} else if (reals.contains(typeOfCalledMethodTemp)
				&& reals.contains(typeOfDefinitionTemp)) {
			return true;
		} else if (bool.contains(typeOfCalledMethodTemp)
				&& bool.contains(typeOfDefinitionTemp)) {
			return true;
		} else if (strings.contains(typeOfCalledMethodTemp)
				&& strings.contains(typeOfDefinitionTemp)) {
			if (typeOfDefinitionTemp.equals("char")
					&& typeOfCalledMethodTemp.equals("char")) {
				return true;
			} else if (typeOfDefinitionTemp.equals("string")
					&& (typeOfCalledMethodTemp.equals("char") || typeOfCalledMethodTemp
							.equals("string"))) {
				return true;
			} else {
				System.out.println("Incompatible types: " + typeOfCalledMethod
						+ ", " + typeOfDefinition);
				return false;
			}
		} else {
			System.out.println("Incompatible types: " + typeOfCalledMethod
					+ ", " + typeOfDefinition);
			return false;
		}
	}

	public void checkWhileExpression(String type) throws Exception {
		// System.out.println("Booleano = " + type);
		if (type == null || !type.equals("boolean")) {
			throw new Exception(
					"While expression must receive a type boolean. Found: "
							+ type + ". Error in line: " + lineError);
		}
	}

	public void checkBooleanExpression(String type) throws Exception {
		// System.out.println("Booleano = " + type);
		if (type == null || !type.equals("boolean")) {
			throw new Exception(
					"Boolean expression must receive a type boolean. Found: "
							+ type + ". Error in line: " + lineError);
		}
	}
}