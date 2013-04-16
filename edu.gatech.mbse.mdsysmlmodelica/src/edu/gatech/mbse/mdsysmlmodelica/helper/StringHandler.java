/*
 * The following is a BSD 3-Clause License
 * 
 * Copyright (c) 2013, Georgia Institute of Technology
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following 
 * conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer 
 * in the documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the Georgia Institute of Technology nor the names of its contributors may be used to endorse or promote 
 * products derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, 
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 */

package edu.gatech.mbse.mdsysmlmodelica.helper;

import java.util.ArrayList;

/**
 * StringHandler is a helper class to perform operations on strings
 * 
 * @author Axel Reichwein
 */
public class StringHandler {

	public static void main(String[] args) {
		getNextSimcolonExample();
	}

	private static void getNextSimcolonExample() {
		String string = "connect(Pre1.y,And1.u3) ; connect(Pre1.y,And1.u2) annotation(Line(points = {{-19,-50},{-10,-50},{-10,-18},{-2,-18}}, color = {255,0,255}));";
		System.err.println(getNextSemicolonPosition(string, 0,
				"connect(Pre1.y,And1.u3"));
	}

	public static String removeFirstLastCurlBrackets(String value) {
		value = value.trim();
		if (value.length() > 1 && value.charAt(0) == '{'
				&& value.charAt(value.length() - 1) == '}') {
			value = value.substring(1, (value.length() - 1));
		}
		return value;
	}

	public static String removeFirstLastBrackets(String value) {
		value = value.trim();
		if (value.length() > 1 && value.charAt(0) == '('
				&& value.charAt(value.length() - 1) == ')') {
			value = value.substring(1, (value.length() - 1));
		}
		return value;
	}

	public static String removeFirstLastDoubleQuotes(String value) {
		value = value.trim();
		if (value.length() > 1 && value.charAt(0) == '"'
				&& value.charAt(value.length() - 1) == '"') {
			value = value.substring(1, (value.length() - 1));
		}
		return value;
	}

	public static ArrayList<String> unparseArrays(String value) {

		ArrayList<String> lst = new ArrayList<String>();
		int qopen = 0;
		int qopenindex = 0;
		int braceopen = 0;
		int mainbraceopen = 0;
		int i = 0;
		int count = 0;
		value = StringHandler.removeFirstLastCurlBrackets(value);
		// System.err.println(value);
		int length = value.length();
		int subbraceopen = 0;

		for (i = 0; i < length; i++) {
			if (value.charAt(i) == ' ' || value.charAt(i) == ',')
				continue; // ignore any kind of space
			if (value.charAt(i) == '{' && qopen == 0 && braceopen == 0) {

				braceopen = 1;
				mainbraceopen = i;
				continue;
			}
			if (value.charAt(i) == '{') {
				subbraceopen = 1;
			}

			char temp = value.charAt(i);

			if (value.charAt(i) == '}' && braceopen == 1 && qopen == 0
					&& subbraceopen == 0) {
				// closing of a group
				// char * tmp = new char [i -mainbraceopen +5];
				int copylength = i - mainbraceopen + 1;
				// strncpy (tmp, value.toStdString().data() + mainbraceopen ,
				// copylength);
				// tmp [copylength] = 0;
				braceopen = 0;
				// printf("arr[%d]=%s;\n", count, tmp);
				// lst.append(QString(tmp));
				// lst.add(value.substring(value.length() + mainbraceopen,
				// copylength));
				lst.add(value.substring(mainbraceopen, mainbraceopen
						+ copylength));
				// delete tmp;
				count++;
				continue;
			}
			if (value.charAt(i) == '}')
				subbraceopen = 0;

			if (value.charAt(i) == '\"') {
				if (qopen == 0) {
					qopen = 1;
					qopenindex = i;
				} else {
					// its a closing quote
					qopen = 0;
				}
			}
		}
		return lst;
	}

	private static String CONSUME_CHAR(String value, String res, int i) {
		if (value.charAt(i) == '\\') {
			i++;
			switch (value.charAt(i)) {
			case '\'':
				res = res + '\'';
				break;
			case '"':
				res = res + '\"';
				break;
			// case '?': res.append('\?'); break;
			// case '\\': res.append('\\'); break;
			// case 'a': res.append('\a'); break;
			// case 'b': res.append('\b'); break;
			// case 'f': res.append('\f'); break;
			// case 'n': res.append('\n'); break;
			// case 'r': res.append('\r'); break;
			// case 't': res.append('\t'); break;
			// case 'v': res.append('\v'); break;
			}
		} else {
			res = res + value.charAt(i);
		}
		return res;

	}

	public static ArrayList<String> unparseStrings(String value) {
		// ArrayList<String> lst = new ArrayList<String>();
		value = value.trim();
		value = value.replaceFirst("\\{", "");

		int lastBracketIndex = value.lastIndexOf("}");
		value = value.substring(0, lastBracketIndex);

		String[] values = value.split(",");
		ArrayList<String> trimmedValues = new ArrayList<String>();
		String composedString = "";
		boolean isComposedString = false;
		for (String string : values) {
			if (!isComposedString
					& (string.startsWith("\"") | string.startsWith("{"))
					& !(string.endsWith("\"") | string.endsWith("}"))) {
				composedString = string;
				isComposedString = true;
				continue;
			}
			if (isComposedString) {
				if (!(string.endsWith("\"") | string.endsWith("}"))) {
					composedString = composedString + "," + string;
					continue;
				} else {
					composedString = composedString + "," + string;
					composedString = composedString.trim();
					trimmedValues.add(composedString);
					isComposedString = false;
					continue;
				}
			}
			string = string.trim();
			trimmedValues.add(string);
		}

		return trimmedValues;
	}

	public static ArrayList<String> unparseComponentStrings(String value) {
		value = value.trim();
		value = value.replaceFirst("\\{", "");

		int lastBracketIndex = value.lastIndexOf("}");
		value = value.substring(0, lastBracketIndex);

		String[] values = value.split(",");
		ArrayList<String> trimmedValues = new ArrayList<String>();
		String composedString = "";
		boolean isComposedString = false;
		for (String string : values) {
			if (!isComposedString
					& (string.startsWith("\"") | string.startsWith("{"))
					& !(string.endsWith("\"") | string.endsWith("}"))) {
				composedString = string;
				isComposedString = true;
				continue;
			}
			if (isComposedString) {
				if (!(string.endsWith("\"") | string.endsWith("}"))) {
					composedString = composedString + "," + string;
					continue;
				} else {
					if (composedString.startsWith("{") & string.endsWith("}")) {
						// arraySize
						composedString = composedString + "," + string;
						composedString = composedString.trim();
						trimmedValues.add(composedString);
						isComposedString = false;
						continue;
					}
					composedString = composedString + string;
					composedString = composedString.trim();
					trimmedValues.add(composedString);
					isComposedString = false;
					continue;
				}
			}
			string = string.trim();
			trimmedValues.add(string);
		}

		return trimmedValues;
	}

	public static String getConnectEndsString(String value) {
		value = value.trim();
		String connectEndsString = "";
		int i = 0;

		// find the first bracket (i.e. after "connect")
		while (value.charAt(i) != '(') {
			i++;
			value = CONSUME_CHAR(value, value, i);
		}

		while (value.charAt(i) == '(') { // start token, i.e. connect(
			i++;
			while (value.charAt(i) != ')') { // stop token
				connectEndsString = CONSUME_CHAR(value, connectEndsString, i);
				i++;
			}
			return connectEndsString;
		}
		return null; // ERROR?
	}

	public static int getNextSemicolonPosition(String entireString,
			int subStringStart, String subString) {
		int i = subStringStart + subString.length() - 1;

		if (i >= 0 && i < entireString.length()) {
			while (entireString.charAt(i) != ';') {
				i++;

				if (entireString.charAt(i) == ';') {
					return i;
				}
				if (i == entireString.length()) {
					return -1;
				}
			}
		}

		return -1;
	}

	public static ArrayList<String> getConnectEnds(String string) {
		ArrayList<String> ends = new ArrayList<String>();
		String connectdEndsString = getConnectEndsString(string);
		if (connectdEndsString != null) {
			String[] splitted = connectdEndsString.split(",");
			if (splitted.length == 2) {
				ends.add(splitted[0].trim());
				ends.add(splitted[1].trim());

				return ends;
			}
		}
		return null;
	}

}
