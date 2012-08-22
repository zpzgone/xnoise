/* xnoise-serial-button.vala
 *
 * Copyright (C) 2012  Jörn Magens
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

public class Xnoise.SerialButton : Gtk.Box {
    private CssProvider provider;
    
    private HashTable<string,SerialItem> sitems = new HashTable<string,SerialItem>(str_hash, str_equal);
    
    public signal void sign_selected(string name);
    
    private class SerialItem : Gtk.ToggleButton {
        private unowned SerialButton sb;
        public string item_name;
        
        public SerialItem(SerialButton sb, string item_name) {
            
            this.sb = sb;
            this.item_name = item_name;
            
            this.set_can_focus(false);
            this.get_style_context().add_provider(sb.provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        }
    }
    
    public SerialButton() {
        GLib.Object(orientation:Orientation.HORIZONTAL, spacing:0);
        this.set_homogeneous(true);
        
        try {
            this.provider = new CssProvider();
            this.provider.load_from_data(CSS, -1);
            this.get_style_context().add_class("XnoiseSerialButton");
        }
        catch(Error e) {
            print("Xnoise CSS Error: %s\n", e.message);
        }
    }

    public int item_count {
        get { return (int)this.get_children().length(); }
    }

    public bool has_item(string? name) {
        if(name == null)
            return false;
        
        if(sitems.lookup(name) == null)
            return false;
        return true;
    }

    public string? get_active_name() {
        if(active_item == null)
            return null;
        else
            return active_item.item_name;
    }

    public bool insert(string? name, string? txt) {
        if(txt == null || name == null)
            return false;
        
        if(sitems.lookup(name) != null)
            return false;
        
        var si = new SerialItem(this, name);
        
        si.add(new Gtk.Label(txt));
        this.add(si);
        
        sitems.insert(name, si);
        
        si.button_press_event.connect( (s,e) => {
            this.select(((SerialItem)s).item_name, true);
            return true;
        });
        
        si.show_all();
        if(item_count == 1) {
            this.select(name, true);
        }
        return true;
    }

    private unowned SerialItem? active_item = null;

    public void select_first() {
        GLib.List<Widget> l = this.get_children();
        if(l.length() == 0)
            return;
        
        Widget? w = (Widget)l.data;
        if(w == null)
            return;
        
        select(((SerialItem)w).item_name, true);
    }
    
    public void select(string name, bool emit_signal = true) {
        if(name == null)
            return;
        
        SerialItem? si;
        
        if((si = sitems.lookup(name)) == null) {
            print("SerialItem %s not available\n", name);
            return;
        }
        
        if(active_item != null)
            active_item.set_active(false);
        
        si.set_active(true);
        active_item = si;
        
        if(emit_signal)
            this.sign_selected(name);
    }

    public new void set_sensitive(string name, bool sensitive_status) {
        if(name == null)
            return;
        
        SerialItem? si;
        
        if((si = sitems.lookup(name)) == null) {
            print("SerialItem %s not available.\n", name);
            return;
        }
        
        si.set_sensitive(sensitive_status);
    }

    public void del(string name) {
        if(name == null)
            return;
        
        Widget? si;
        
        if((si = sitems.lookup(name)) == null) {
            print("SerialItem %s not available. Cannot delete\n", name);
            return;
        }
        bool removed_active = false;
        if(active_item == (SerialItem)si) {
            active_item.set_active(false);
            removed_active = true;
            active_item = null;
        }
        this.remove(si);
        sitems.remove(name);
        si.destroy();
        if(removed_active)
            select_first();
    }
    
//    private Gtk.Widget? get_at_index(int idx) {
//        return this.get_children().nth_data(idx);
//    }
    
    private static const string CSS = """
        .XnoiseSerialButton .button {
            -GtkToolbar-button-relief:  normal;
            border-radius:              0px 0px 0px 0px;
            border-style:               solid;
            border-width:               1px 0px 1px 1px;
            -unico-outer-stroke-width:  1px 0px 1px 0px;
            -unico-outer-stroke-radius: 0px 0px 0px 0px;
        }
        
        .XnoiseSerialButton .button:active,
        .XnoiseSerialButton .button:insensitive {
            -unico-outer-stroke-width:  1px 0px 1px 0px;
        }

        .XnoiseSerialButton .button:first-child {
            border-radius:              3px 0px 0px 3px;
            border-width:               1px 0px 1px 1px;
            -unico-outer-stroke-width:  1px 0px 1px 1px;
        }

        .XnoiseSerialButton .button:last-child {
            border-radius:              0px 3px 3px 0px;
            border-width:               1px;
            -unico-outer-stroke-width:  1px 1px 1px 0px;
        }
    """;
}

