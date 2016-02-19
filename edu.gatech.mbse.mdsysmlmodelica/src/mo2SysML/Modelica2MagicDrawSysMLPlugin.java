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

package mo2SysML;

import java.util.List;

import javax.swing.ImageIcon;

import com.nomagic.magicdraw.actions.*;
import com.nomagic.magicdraw.plugins.Plugin;
import com.nomagic.magicdraw.ui.browser.actions.DefaultBrowserAction;
import com.nomagic.magicdraw.uml.DiagramType;
import com.nomagic.magicdraw.core.Application;

import com.nomagic.magicdraw.ui.ProjectWindowsManager;
import com.nomagic.magicdraw.ui.ProjectWindow;
import com.nomagic.magicdraw.ui.WindowComponentInfo;
import com.nomagic.magicdraw.ui.WindowsManager;


public class Modelica2MagicDrawSysMLPlugin extends Plugin {
    
    public void init() {
//    	Application.getInstance().getGUILog().showMessage("My Plug-in xxx initialized.");
//    	javax.swing.JOptionPane.showMessageDialog( null, "My Plugin init");
    	ActionsConfiguratorsManager manager = ActionsConfiguratorsManager.getInstance();
        MBSEBrowserConfigurator mbseConfigurator = null;
        
        
        // maybe we could use only one configurator and add all the actions in there.
		mbseConfigurator = new MBSEBrowserConfigurator();
        
        manager.addContainmentBrowserContextConfigurator( mbseConfigurator );
        
        
     }

    /**
     * @see com.nomagic.magicdraw.plugins.Plugin#close()
     */
    public boolean close()
    {
        return true;
    }

    /**
     * @see com.nomagic.magicdraw.plugins.Plugin#isSupported()
     */
    public boolean isSupported()
    {
        return true;
    }


}

