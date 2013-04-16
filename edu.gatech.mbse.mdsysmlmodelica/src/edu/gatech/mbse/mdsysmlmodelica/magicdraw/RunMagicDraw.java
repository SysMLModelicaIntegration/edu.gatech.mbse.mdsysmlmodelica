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

package edu.gatech.mbse.mdsysmlmodelica.magicdraw;

import com.nomagic.magicdraw.core.Application;
import com.nomagic.runtime.*;

import edu.gatech.mbse.mdsysmlmodelica.mo2SysML.Modelica2MagicDrawSysMLPlugin;
import edu.gatech.mbse.mdsysmlmodelica.sys2mo.SysML2ModelicaPlugin;

/**
 * RunMagicDraw launches the MagicDraw application with 2 plugins, one for the
 * Modelica to SysML transformation, and one for the SysMl to Modelica
 * transformation
 * 
 * @author Axel Reichwein
 */
public class RunMagicDraw {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			Modelica2MagicDrawSysMLPlugin modelica2SysMLPlugin = new Modelica2MagicDrawSysMLPlugin();
			SysML2ModelicaPlugin sysML2ModelicaPlugin = new SysML2ModelicaPlugin();
			Application app = Application.getInstance();
			app.start(true, false, false, args, null);
			modelica2SysMLPlugin.init();
			sysML2ModelicaPlugin.init();
		} catch (ApplicationExitedException e) {
			e.printStackTrace();
		}

	}

}