/* xnoise-settings-widget.vala
 *
 * Copyright (C) 2009-2012  Jörn Magens
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  The Xnoise authors hereby grant permission for non-GPL compatible
 *  GStreamer plugins to be used and distributed together with GStreamer
 *  and Xnoise. This permission is above and beyond the permissions granted
 *  by the GPL license by which Xnoise is covered. If you modify this code
 *  you may extend this exception to your version of the code, but you are not
 *  obligated to do so. If you do not wish to do so, delete this exception
 *  statement from your version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA.
 *
 * Author:
 *     Jörn Magens
 */

using Gtk;

using Xnoise;
using Xnoise.PluginModule;
using Xnoise.Resources;


private class Xnoise.SettingsWidget : Gtk.Box {
    private Builder builder;
    private const string SETTINGS_UI_FILE = Config.XN_UIDIR + "settings.ui";
    private Notebook notebook;
    private SpinButton sb;
    private int fontsizeMB;
    private CheckButton switch_showL;
    private CheckButton switch_compact;
    private CheckButton switch_usestop;
    private CheckButton switch_hoverimage;
    private CheckButton switch_quitifclosed;
    private CheckButton switch_use_notifications;
    private CheckButton switch_equalizer;
    private AddMediaWidget add_media_widget;
    private SizeGroup plugin_label_sizegroup;
    
    private enum NotebookTabs {
        GENERAL = 0,
        MEDIA,
        N_FIXED_TABS
    }

    private enum DisplayColums {
        TOGGLE,
        TEXT,
        N_COLUMNS
    }
    
    public signal void sign_finish();
    public void select_general_tab() {
        if(this.notebook == null)
            return;
        this.notebook.set_current_page(NotebookTabs.GENERAL);
    }
    
    public SettingsWidget() {
        GLib.Object(orientation:Orientation.VERTICAL, spacing:0);
        this.setup_widgets();
        initialize_members();
        connect_signals();
    }

//    public string get_view_name() {
//        return "Settings";
//    }
    
    private void connect_signals() {
        assert(switch_usestop != null);
        switch_usestop.clicked.connect(this.on_checkbutton_usestop_clicked);
        
        assert(switch_showL != null);
        switch_showL.clicked.connect(this.on_checkbutton_show_lines_clicked);
        
        assert(switch_hoverimage != null);
        switch_hoverimage.clicked.connect(this.on_checkbutton_mediabr_hoverimage_clicked);
        
        assert(switch_compact != null);
        switch_compact.clicked.connect(this.on_checkbutton_compact_clicked);
        
        assert(switch_quitifclosed != null);
        switch_quitifclosed.clicked.connect(this.on_checkbutton_quitifclosed_clicked);
        
        assert(switch_equalizer != null);
        switch_equalizer.clicked.connect(this.on_switch_use_equalizer_clicked);
        
        assert(switch_use_notifications != null);
        switch_use_notifications.clicked.connect(this.on_switch_use_notifications_clicked);
        
        sb.changed.connect(this.on_mb_font_changed);
    }

    private void initialize_members() {
        //Visible Cols
        
        //Treelines
        switch_showL.active = Params.get_bool_value("use_treelines");
        
        //compact layout / Application menu
        switch_compact.active = Params.get_bool_value("compact_layout");
        
        //use stop button
        switch_quitifclosed.active = Params.get_bool_value("quit_if_closed");
        
        switch_equalizer.active = !Params.get_bool_value("not_use_eq");
        
        switch_usestop.active = Params.get_bool_value("usestop");
        
        //not_show_art_on_hover_image
        switch_hoverimage.active = !Params.get_bool_value("not_show_art_on_hover_image");
        
        switch_use_notifications.active = !Params.get_bool_value("not_use_notifications");
        
        // SpinButton
        if((Params.get_int_value("fontsizeMB") >= 7)&&
            (Params.get_int_value("fontsizeMB") <= 14))
            sb.set_value((double)Params.get_int_value("fontsizeMB"));
        else
            sb.set_value(9.0);
    }

    private void on_mb_font_changed(Gtk.Editable sender) {
        if((int)(((Gtk.SpinButton)sender).value) < 7 ) ((Gtk.SpinButton)sender).value = 7;
        if((int)(((Gtk.SpinButton)sender).value) > 15) ((Gtk.SpinButton)sender).value = 15;
        fontsizeMB = (int)((Gtk.SpinButton)sender).value;
//        main_window.musicBr.fontsizeMB = fontsizeMB;
        global.fontsize_dockable = fontsizeMB;
        Params.set_int_value("fontsizeMB", fontsizeMB);
    }

    private void on_checkbutton_show_lines_clicked() {
        if(this.switch_showL.active) {
            Params.set_bool_value("use_treelines", true);
            main_window.musicBr.use_treelines = true;
        }
        else {
            Params.set_bool_value("use_treelines", false);
            main_window.musicBr.use_treelines = false;
        }
    }
    
    private void on_checkbutton_compact_clicked() {
        if(this.switch_compact.active) {
            Params.set_bool_value("compact_layout", true);
            main_window.compact_layout = true;
        }
        else {
            Params.set_bool_value("compact_layout", false);
            main_window.compact_layout = false;
        }
    }
    
    private void on_switch_use_notifications_clicked() {
        if(this.switch_use_notifications.active) {
            Params.set_bool_value("not_use_notifications", false);
            Main.instance.use_notifications = true;
        }
        else {
            Params.set_bool_value("not_use_notifications", true);
            Main.instance.use_notifications = false;
        }
    }
    
    private void on_switch_use_equalizer_clicked() {
        if(!this.switch_equalizer.active) {
            Params.set_bool_value("not_use_eq", true);
            main_window.use_eq = false;
            gst_player.deactivate_equalizer();
        }
        else {
            Params.set_bool_value("not_use_eq", false);
            main_window.use_eq = true;
            gst_player.activate_equalizer();
        }
    }
    
    private void on_checkbutton_quitifclosed_clicked() {
        if(this.switch_quitifclosed.active) {
            Params.set_bool_value("quit_if_closed", true);
            if(tray_icon != null)
                tray_icon.visible = false;
            main_window.quit_if_closed = true;
        }
        else {
            Params.set_bool_value("quit_if_closed", false);
            if(tray_icon == null) {
                tray_icon = new TrayIcon();
            }
            tray_icon.visible = true;
            main_window.quit_if_closed = false;
        }
    }
    
    private void on_checkbutton_usestop_clicked() {
        if(this.switch_usestop.active) {
            Params.set_bool_value("usestop", true);
            main_window.usestop = true;
        }
        else {
            Params.set_bool_value("usestop", false);
            main_window.usestop = false;
        }
    }
    
    private void on_checkbutton_mediabr_hoverimage_clicked() {
        if(!this.switch_hoverimage.active) {
            Params.set_bool_value("not_show_art_on_hover_image", true);
            main_window.not_show_art_on_hover_image = true;
        }
        else {
            Params.set_bool_value("not_show_art_on_hover_image", false);
            main_window.not_show_art_on_hover_image = false;
        }
    }
    
    private void on_back_button_clicked() {
        Params.write_all_parameters_to_file();
        main_window.show_content();//mainview_box.select_main_view(TRACKLIST_VIEW_NAME);
        sign_finish();
    }

    private void add_plugin_tabs() {
        int count = 0;
        
        foreach(string name in plugin_loader.plugin_htable.get_keys()) {
            unowned PluginModule.Container p = plugin_loader.plugin_htable.lookup(name);
            if((p.activated) && (p.configurable)) {
                Widget? w = p.settingwidget();
                
                if(w!=null) {
                    var b = new Gtk.Box(Orientation.VERTICAL, 0);
                    Gtk.Image i;
                    if(IconTheme.get_default().has_icon(p.info.icon))
                        i = new Gtk.Image.from_icon_name(p.info.icon, IconSize.BUTTON);
                    else
                        i = new Gtk.Image.from_stock(Stock.EXECUTE ,IconSize.BUTTON);
                    string n = name.substring(0, 1).up() + name.substring(1, name.length - 1);
                    var l = new Gtk.Label(n);
                    l.max_width_chars = 10;
                    b.pack_start(i, true, true, 0);
                    b.pack_start(l, false, false, 0);
                    var scw = new ScrolledWindow(null, null);
                    scw.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
                    scw.add_with_viewport(w);
                    b.show_all();
                    notebook.append_page(scw, b);
                    scw.show_all();
                }
                
                count++;
            }
        }
        this.number_of_tabs = NotebookTabs.N_FIXED_TABS + count;
    }
    
    public void select_media_tab() {
        if(this.notebook == null)
            return;
        print("select media tab\n");
        this.notebook.set_current_page(NotebookTabs.MEDIA);
    }

    private void remove_plugin_tabs() {
        //remove all plugin tabs, before re-adding them
        int number_of_plugin_tabs = notebook.get_n_pages();
        for(int i = NotebookTabs.N_FIXED_TABS; i < number_of_plugin_tabs; i++) {
            notebook.remove_page(-1); //remove last page
        }
    }

    private int number_of_tabs;
    private void reset_plugin_tabs(string name) {
        //just remove all dynamically added tabs and recreate them
        remove_plugin_tabs();
        add_plugin_tabs();
        this.show_all();
    }

    private bool setup_widgets() {
        builder = new Builder();
        try {
            this.builder.add_from_file(SETTINGS_UI_FILE);
            
            var general_label = this.builder.get_object("label1") as Gtk.Label;
            general_label.set_text(_("Settings"));
            var media_label = this.builder.get_object("media_label") as Gtk.Label;
            media_label.set_text(_("Media"));
            
            plugin_label_sizegroup = new Gtk.SizeGroup(SizeGroupMode.HORIZONTAL);
            
            switch_showL = this.builder.get_object("cb_showlines") as Gtk.CheckButton;
            switch_showL.can_focus = false;
            switch_showL.set_label(_("Grid lines in media browser"));
            
            switch_hoverimage = this.builder.get_object("cb_hoverimage") as CheckButton;
            switch_hoverimage.can_focus = false;
            switch_hoverimage.set_label(_("Show picture on hover album image"));
            
            switch_compact = this.builder.get_object("cb_compact") as CheckButton;
            switch_compact.can_focus = false;
            switch_compact.set_label(_("Use Compact Menu"));
            
            switch_usestop = this.builder.get_object("cb_usestop") as CheckButton;
            switch_usestop.can_focus = false;
            switch_usestop.set_label(_("Show Stop button"));
            
            switch_quitifclosed = this.builder.get_object("cb_quitifclosed") as CheckButton;
            switch_quitifclosed.can_focus = false;
            switch_quitifclosed.set_label(_("Quit on window close"));

            switch_use_notifications = this.builder.get_object("cb_use_notifications") as CheckButton;
            switch_use_notifications.can_focus = false;
            switch_use_notifications.set_label(_("Use desktop notifications"));
            
            switch_equalizer = this.builder.get_object("cb_equalizer") as CheckButton;
            switch_equalizer.can_focus = false;
            switch_equalizer.set_label(_("Use Equalizer"));
//            plugin_label_sizegroup.add_widget(label_equalizer);
            
            notebook = this.builder.get_object("notebook1") as Gtk.Notebook;
            
            Gtk.Image back_image;
            
            if(IconTheme.get_default().has_icon("network-transmit-symbolic"))
                back_image = new Gtk.Image.from_icon_name("user-home-symbolic", IconSize.LARGE_TOOLBAR);
            else
                back_image = new Gtk.Image.from_stock(Stock.HOME, IconSize.SMALL_TOOLBAR);
            var back_button = new Button();
            back_button.add(back_image);
            back_button.tooltip_markup = Markup.printf_escaped(_("Go Back"));
            back_button.clicked.connect(on_back_button_clicked);
            notebook.set_action_widget(back_button, PackType.START);
            back_button.show_all();
            notebook.scrollable = false;
            notebook.show_border = false;
            this.pack_start(notebook, true, true, 0);

            var fontsize_label = this.builder.get_object("fontsize_label") as Gtk.Label;
            fontsize_label.label = _("Media browser fontsize");
            
            sb = this.builder.get_object("spinbutton1") as Gtk.SpinButton;
            sb.configure(new Gtk.Adjustment(8.0, 7.0, 14.0, 1.0, 1.0, 0.0), 1.0, (uint)0);
            sb.set_numeric(true);
            
            var mediabox = this.builder.get_object("mediabox") as Gtk.Box;
            add_media_widget = new AddMediaWidget();
            mediabox.pack_start(add_media_widget, true, true, 0);
            var music_store_box = this.builder.get_object("music_store_box") as Gtk.Box;
            var lyric_provider_box = this.builder.get_object("lyric_provider_box") as Gtk.Box;
            var additionals_box = this.builder.get_object("additionals_box") as Gtk.Box;
            var gui_box = this.builder.get_object("box6") as Gtk.Box;
            
            //Category headlines
            var gui_label = this.builder.get_object("label2") as Gtk.Label;
            gui_label.use_markup = true;
            gui_label.set_markup(Markup.printf_escaped("<b>%s</b>", _("User Interface:")));
            
            var lyric_provider_label = this.builder.get_object("lyric_provider_label") as Gtk.Label;
            lyric_provider_label.use_markup = true;
            lyric_provider_label.set_markup(Markup.printf_escaped("<b>%s</b>", _("Lyrics:")));
            
            var additionals_label = this.builder.get_object("additionals_label") as Gtk.Label;
            additionals_label.use_markup = true;
            additionals_label.set_markup(Markup.printf_escaped("<b>%s</b>", _("Additional:")));
            
            var music_store_label = this.builder.get_object("music_store_label") as Gtk.Label;
            music_store_label.use_markup = true;
            music_store_label.set_markup(Markup.printf_escaped("<b>%s</b>", _("Music Stores:").strip()));
            
            Timeout.add_seconds(1, () => {
                if(plugin_loader.loaded == false) {
                    print("plugin loader not ready - try agan in one second ...\n");
                    return true;
                }
                insert_plugin_switches(lyric_provider_box, PluginCategory.LYRICS_PROVIDER);
                insert_plugin_switches(music_store_box, PluginCategory.MUSIC_STORE);
                insert_plugin_switches(gui_box, PluginCategory.GUI);
                insert_plugin_switches(additionals_box, PluginCategory.ADDITIONAL);
                insert_plugin_switches(additionals_box, PluginCategory.UNSPECIFIED);
                insert_plugin_switches(additionals_box, PluginCategory.ALBUM_ART_PROVIDER);
                
                add_plugin_tabs();
                return false;
            });
        }
        catch (GLib.Error e) {
            var msg = new Gtk.MessageDialog(null, Gtk.DialogFlags.MODAL, Gtk.MessageType.ERROR,
                Gtk.ButtonsType.OK, "Failed to build settings window! \n" + e.message);
            msg.run();
        }
        return true;
    }
    
    private void insert_plugin_switches(Box box, PluginCategory cat) {
        List<unowned string> list = plugin_loader.plugin_htable.get_keys();
        list.sort(strcmp);
        list.reverse();
        foreach(string plugin_name in list) {
            if(plugin_loader.plugin_htable.lookup(plugin_name).info.category != cat)
                continue;
            var plugin_switch = new PluginSwitch(plugin_name, this.plugin_label_sizegroup);
            box.pack_start(plugin_switch,
                           false,
                           false,
                           0
                           );
            plugin_switch.sign_plugin_activestate_changed.connect(reset_plugin_tabs);
        }
        if(box.get_children().length() > 1) {
            box.set_no_show_all(false);
            box.show_all();
        }
        else {
            box.hide();
            box.set_no_show_all(true);
        }
    }
}

