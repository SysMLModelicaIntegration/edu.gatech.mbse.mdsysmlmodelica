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

package edu.gatech.mbse.mdsysmlmodelica.mo2SysML;

import org.eclipse.emf.common.util.EList;

import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Element;

public class ModelicaComponentData {
	
	private String typeQName;
	private Element type;
	private String name;
	private String comment; 
	private String visibility;
	private boolean isFinal;
	private boolean isFlow;
	private boolean isStream;
	private boolean isReplaceable;
	private String variability;
	private String innerouter;
	private String causality;
	private EList<String> arraySize;
	public String getTypeQName() {
		return typeQName;
	}
	public void setTypeQName(String typeQName) {
		this.typeQName = typeQName;
	}
	public Element getType() {
		return type;
	}
	public void setType(Element type) {
		this.type = type;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public String getVisibility() {
		return visibility;
	}
	public void setVisibility(String visibility) {
		this.visibility = visibility;
	}
	public boolean isFinal() {
		return isFinal;
	}
	public void setFinal(boolean isFinal) {
		this.isFinal = isFinal;
	}
	public boolean isFlow() {
		return isFlow;
	}
	public void setFlow(boolean isFlow) {
		this.isFlow = isFlow;
	}
	public boolean isStream() {
		return isStream;
	}
	public void setStream(boolean isStream) {
		this.isStream = isStream;
	}
	public boolean isReplaceable() {
		return isReplaceable;
	}
	public void setReplaceable(boolean isReplaceable) {
		this.isReplaceable = isReplaceable;
	}
	public String getVariability() {
		return variability;
	}
	public void setVariability(String variability) {
		this.variability = variability;
	}
	public String getInnerouter() {
		return innerouter;
	}
	public void setInnerouter(String innerouter) {
		this.innerouter = innerouter;
	}
	public String getCausality() {
		return causality;
	}
	public void setCausality(String causality) {
		this.causality = causality;
	}
	public EList<String> getArraySize() {
		return arraySize;
	}
	public void setArraySize(EList<String> arraySize) {
		this.arraySize = arraySize;
	}
	
	

}
