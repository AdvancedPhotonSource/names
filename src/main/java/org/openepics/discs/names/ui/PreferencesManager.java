/*
 * This software is Copyright by the Board of Trustees of Michigan
 * State University (c) Copyright 2012.
 * 
 * You may use this software under the terms of the GNU public license
 *  (GPL). The terms of this license are described at:
 *       http://www.gnu.org/licenses/gpl.txt
 * 
 * Contact Information:
 *   Facilitty for Rare Isotope Beam
 *   Michigan State University
 *   East Lansing, MI 48824-1321
 *   http://frib.msu.edu
 * 
 */
package org.openepics.discs.names.ui;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.PostConstruct;
import javax.enterprise.context.SessionScoped;
import javax.inject.Named;

/**
 * Manages user preferences.
 *
 * @author Vasu V <vuppala@frib.msu.org>
 */
@Named
@SessionScoped
public class PreferencesManager implements Serializable {

    public static class Theme {
        private final int id;
        private final String name;
        private final String code;
        
        public Theme(int id, String name, String code) {
            this.id = id;
            this.name = name;
            this.code = code;
        }

        public int getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        public String getCode() {
            return code;
        }
        
    }
    
    private static final Logger logger = Logger.getLogger("org.openepics.names");
    private String currentTheme;
    private  final String defaultTheme = "saga";
    private List<Theme> themes; 
    
    /**
     * Creates a new instance of PreferencesManager
     */
    public PreferencesManager() {
    }

    @PostConstruct
    public void init() {
        themes = new ArrayList<>();
        themes.add(new Theme(0, "Saga", "saga"));
        themes.add(new Theme(1, "Arya", "arya"));
        themes.add(new Theme(0, "Vela", "vela"));               
        themes.add(new Theme(0, "Luna Amber", "luna-amber"));
        themes.add(new Theme(0, "Luna Blue", "luna-blue"));
        themes.add(new Theme(0, "Luna Green", "luna-green"));
        themes.add(new Theme(0, "Luna Pink", "luna-pink"));
        themes.add(new Theme(0, "Nova Colored", "nova-colored"));
        themes.add(new Theme(0, "Nova Dark", "nova-dark"));
        themes.add(new Theme(0, "Nova Light", "nova-light"));

        currentTheme = defaultTheme;
    }

    public  String getDefaultTheme() {
        return defaultTheme;
    }

    public String getCurrentTheme() {
        return currentTheme;
    }

    public void setCurrentTheme(String currentTheme) {
        this.currentTheme = currentTheme;
    }

    public void saveTheme() {
        logger.log(Level.INFO, "Selected theme: " + currentTheme);
    }

    public List<Theme> getThemes() {
        return(themes);
    }
}
