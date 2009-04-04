/* xnoise-music-browser.vala
 *
 * Copyright (C) 2009  Jörn Magens
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 * 	Jörn Magens
 */

using GLib;
using Gtk;
using Gdk;

public class Xnoise.MusicBrowser : TreeView {
	public new TreeStore model;
	private TreeStore dummymodel;
	private Gdk.Pixbuf artist_pixb;
	private Gdk.Pixbuf album_pixb;
	private Gdk.Pixbuf title_pixb;
	private bool dragging;
	public signal void sign_activated();
	private const TargetEntry[] target_list = {
		{"text/uri-list", 0, 0}
	};// This is not a very long list but uris are so universal

	public MusicBrowser() {
		create_model();
		set_pixbufs();
		add_data_to_model();
		setup_view();
		set_model(model); 
		this.get_selection().set_mode(SelectionMode.MULTIPLE);		

		Gtk.drag_source_set(
			this,
			Gdk.ModifierType.BUTTON1_MASK, 
			this.target_list,
			Gdk.DragAction.COPY|
			Gdk.DragAction.MOVE);

		this.dragging = false;
		
		this.row_activated        += this.on_row_activated; 
		this.drag_begin           += this.on_drag_begin;
		this.drag_data_get        += this.on_drag_data_get;
		this.drag_end             += this.on_drag_end;
		this.button_release_event += this.on_button_release;
		this.button_press_event   += this.on_button_press;
	}



	public bool on_button_press(MusicBrowser sender, Gdk.EventButton e) {
		Gtk.TreePath path = null;
		Gtk.TreeViewColumn column;        
		Gtk.TreeSelection selection = this.get_selection();
		int x = (int)e.x; 
		int y = (int)e.y;
		int cell_x, cell_y;

		if(!this.get_path_at_pos(x, y, out path, out column, out cell_x, out cell_y)) 
			return true;
		
		switch(e.button) {
			case 1: {
				if(selection.count_selected_rows()<= 1) { 
					return false;
				}
				else {
					if(selection.path_is_selected(path)) {
						if(((e.state & Gdk.ModifierType.SHIFT_MASK) == Gdk.ModifierType.SHIFT_MASK)|
						   ((e.state & Gdk.ModifierType.CONTROL_MASK) == Gdk.ModifierType.CONTROL_MASK)) {
							selection.unselect_path(path);
						} 
						return true;
					}
					else if(!(((e.state & Gdk.ModifierType.SHIFT_MASK) == Gdk.ModifierType.SHIFT_MASK)|
							((e.state & Gdk.ModifierType.CONTROL_MASK) == Gdk.ModifierType.CONTROL_MASK))) {
						return true; 
					}
					return false;
				}
			}
			case 3: {
				print("button 3\n");
				return false; //TODO check if this is right
			}
		}
		if(!(selection.count_selected_rows()>0 )) 
			selection.select_path(path);
		return false; 
	}


	public bool on_button_release(MusicBrowser sender, Gdk.EventButton e) {
		Gtk.TreePath path;
		Gtk.TreeViewColumn column;
		int cell_x, cell_y;

		if((e.button != 1)|(this.dragging)) {
			this.dragging = false;
			return true;
		}
		if(((e.state & Gdk.ModifierType.SHIFT_MASK) == Gdk.ModifierType.SHIFT_MASK)|
			((e.state & Gdk.ModifierType.CONTROL_MASK) == Gdk.ModifierType.CONTROL_MASK)) {
			return true;
		}

		Gtk.TreeSelection selection = this.get_selection();
		int x = (int)e.x; 
		int y = (int)e.y;
		if(!this.get_path_at_pos(x, y, out path, out column, out cell_x, out cell_y)) return false;
		selection.unselect_all();
		selection.select_path(path);

		return false; 
	}

	private void on_drag_begin(MusicBrowser sender, DragContext context) {
		this.dragging = true;
		Gdk.drag_abort(context, Gtk.get_current_event_time());
		Gtk.TreeSelection selection = this.get_selection();
		if(selection.count_selected_rows() > 1) {
			Gtk.drag_source_set_icon_stock(this, Gtk.STOCK_DND_MULTIPLE);
		}
		else {
			Gtk.drag_source_set_icon_stock(this, Gtk.STOCK_DND);
		}
		return;
	}

	public void on_drag_data_get(MusicBrowser sender, Gdk.DragContext context, Gtk.SelectionData selection, uint info, uint etime) {
		string[] uris = {};
		List<weak TreePath> paths;
		weak Gtk.TreeSelection sel;
		sel = this.get_selection();
		paths = sel.get_selected_rows(null);
		foreach(weak TreePath path in paths) {
				string[] l = this.fill_uri_list(path);
				foreach(weak string u in l) {
					uris += u;
				}
		}
		uris += null;
		selection.set_uris(uris);
	}

	private string[] fill_uri_list(Gtk.TreePath path) {
		TreeIter iter, iterp, iterp2, iterChild, iterChildChild;
		string artist = "";
		string album  = "";
		string title  = "";
		string[] urilist = {};
	
		switch(path.get_depth()) {
			case 1:
				model.get_iter(out iter, path);
				model.get(iter, 1, ref artist);
				for (int i = 0; i < model.iter_n_children(iter); i++) {
					model.iter_nth_child(out iterChild, iter, i);
					string currentalbum = "";
					model.get(iterChild, 1, ref currentalbum);
					for (int j = 0; j <model.iter_n_children(iterChild); j++) {
						model.iter_nth_child(out iterChildChild, iterChild, j);
						string currenttitle = "";
						model.get(iterChildChild, 1, ref currenttitle);
						var dbb = new DbBrowser();
						string uri = dbb.get_uri_for_title(artist, currentalbum, currenttitle);
						urilist += uri;
					}
				}
				break;
			case 2:
				model.get_iter(out iter, path);
				model.get(iter, 1, ref album);
				if (model.iter_parent(out iterp, iter)) {
					model.get(iterp, 1, ref artist);
				}
				for (int i = 0; i < model.iter_n_children(iter); i++) {
					model.iter_nth_child(out iterChild, iter, i);
					string currenttitle = "";
					model.get(iterChild, 1, ref currenttitle);
					var dbb = new DbBrowser();
					string uri = dbb.get_uri_for_title(artist, album, currenttitle);
					urilist +=uri;
				}
				break;
			case 3:
				model.get_iter(out iter, path);
				model.get(iter, 1, ref title);
				if (model.iter_parent(out iterp, iter)) {
					model.get(iterp, 1, ref album);
				}
				if (model.iter_parent(out iterp2, iterp)) {
					model.get(iterp2, 1, ref artist);
				}
				var dbb = new DbBrowser();
				string uri = dbb.get_uri_for_title(artist, album, title);
				urilist += uri;
				break;
		}
		return urilist;		
	}

	private TrackData[] fill_trackdata_list(Gtk.TreePath path) {
		TreeIter iter, iterp, iterp2, iterChild, iterChildChild;
		string artist = "";
		string album = "";
		string title = "";
		TrackData[] td_list = new TrackData[0]; 
	
		switch (path.get_depth()) {
			case 1: //ARTIST
				model.get_iter(out iter, path);
				model.get(iter, 1, ref artist);
				for (int i = 0; i < model.iter_n_children(iter); i++) {
					model.iter_nth_child(out iterChild, iter, i);
					string currentalbum = "";
					model.get(iterChild, 1, ref currentalbum);
					for (int j = 0; j <model.iter_n_children(iterChild); j++) {
						model.iter_nth_child(out iterChildChild, iterChild, j);
						string currenttitle = "";
						model.get(iterChildChild, 1, ref currenttitle);
						TrackData td = TrackData();
						td.Artist = artist;
						td.Album  = currentalbum;
						td.Title  = currenttitle; //TODO: get rid of tmp values
						td_list += td;
					}
				}
				break;
			case 2: //ALBUM
				model.get_iter(out iter, path);
				model.get(iter, 1, ref album);
				if (model.iter_parent(out iterp, iter)) {
					model.get(iterp, 1, ref artist);
				}
				for (int i = 0; i < model.iter_n_children(iter); i++) {
					model.iter_nth_child(out iterChild, iter, i);
					string currenttitle = "";
					model.get(iterChild, 1, ref currenttitle);
					TrackData td = TrackData();
					td.Artist = artist;
					td.Album  = album;
					td.Title  = currenttitle;
					td_list += td;
				}
				break;
			case 3: //TITLE
				model.get_iter(out iter, path);
				model.get(iter, 1, ref title);
				if (model.iter_parent(out iterp, iter)) {
					model.get(iterp, 1, ref album);
				}
				if (model.iter_parent(out iterp2, iterp)) {
					model.get(iterp2, 1, ref artist);
				}
				TrackData td = TrackData();
				td.Artist = artist;
				td.Album  = album;
				td.Title  = title;
				td_list += td;
				break;
		}		
		return td_list;
	}

	public void on_drag_end(MusicBrowser sender, Gdk.DragContext context) { 
		this.dragging = false;
		this.unset_rows_drag_dest();
		Gtk.drag_dest_set( 
			this,
			Gtk.DestDefaults.ALL,
			this.target_list, 
			Gdk.DragAction.COPY|
			Gdk.DragAction.MOVE);
	}

	private void on_row_activated(MusicBrowser sender, TreePath path, TreeViewColumn column){
		if (path.get_depth()>1) {
			TrackData[] td_list = this.fill_trackdata_list(path);
			this.add_songs(td_list, true);
			td_list = null;
		}
		else {
			this.expand_row(path, false);
		}
	}

	private void add_songs(TrackData[] td_list, bool imediate_play = false)	{
		var dbBr = new DbBrowser();
		int i = 0;
		TreeIter iter;
		TreeIter iter_2 = TreeIter();
		if(imediate_play) Main.instance().main_window.trackList.reset_play_status_for_title();
		foreach(weak TrackData td in td_list) {
			string uri = dbBr.get_uri_for_title(td.Artist, td.Album, td.Title); 
			int tracknumber = dbBr.get_tracknumber_for_title(td.Artist, td.Album, td.Title);
			if(imediate_play) {
				if(i==0) {
					Main.instance().add_track_to_gst_player(uri);
					iter = Main.instance().main_window.trackList.insert_title(
						TrackStatus.PLAYING, 
						null, 
						tracknumber,
						Markup.printf_escaped("%s", td.Title), 
						Markup.printf_escaped("%s", td.Album), 
						Markup.printf_escaped("%s", td.Artist), 
						uri);
					Main.instance().main_window.trackList.set_state_picture_for_title(iter, TrackStatus.PLAYING);
					iter_2 = iter;
				}
				else {
					iter = Main.instance().main_window.trackList.insert_title(
					    TrackStatus.STOPPED, 
					    null, 
					    tracknumber,
					    Markup.printf_escaped("%s", td.Title), 
					    Markup.printf_escaped("%s", td.Album), 
					    Markup.printf_escaped("%s", td.Artist), 
					    uri);			
				}
				i++;
			}
			else {
					iter = Main.instance().main_window.trackList.insert_title(
					    TrackStatus.STOPPED, 
					    null, 
					    tracknumber,
					    Markup.printf_escaped("%s", td.Title), 
					    Markup.printf_escaped("%s", td.Album), 
					    Markup.printf_escaped("%s", td.Artist), 
					    uri);			
			}
		}
		if (imediate_play) Main.instance().main_window.trackList.set_focus_on_iter(ref iter_2);		
	}

	public bool change_model_data() {
		dummymodel = new TreeStore(2, typeof(Gdk.Pixbuf), typeof(string));
		set_model(dummymodel);
		model.clear();
		add_data_to_model();
		set_model(model);
		this.set_sensitive(true);
		return false;
	}

	private void create_model() {	// DATA
		model = new TreeStore(2, typeof(Gdk.Pixbuf), typeof(string));
	}
	
	private bool add_data_to_model() {
		DbBrowser artists_browser = new DbBrowser();
		DbBrowser albums_browser  = new DbBrowser();
		DbBrowser titles_browser  = new DbBrowser();

		string[] artistArray;
		string[] albumArray;
		string[] titleArray;

		TreeIter iter_artist, iter_album, iter_title;	
		artistArray = artists_browser.get_artists();
		foreach(weak string artist in artistArray) { 	              //ARTISTS
			model.prepend(out iter_artist, null); 
			model.set(iter_artist,  	
				MusicBrModColumn.ICON, artist_pixb,		
				MusicBrModColumn.VIS_TEXT, artist,		
				-1); 
			albumArray = albums_browser.get_albums(artist);
			foreach(weak string album in albumArray) { 			    //ALBUMS
				model.prepend(out iter_album, iter_artist); 
				model.set(iter_album,  	
					MusicBrModColumn.ICON, album_pixb,		
					MusicBrModColumn.VIS_TEXT, album,		
					-1); 
				titleArray = titles_browser.get_titles(artist, album);
				foreach(weak string title in titleArray) {	         //TITLES
					model.prepend(out iter_title, iter_album); 
					model.set(iter_title,  	
						MusicBrModColumn.ICON, title_pixb,		
						MusicBrModColumn.VIS_TEXT, title,		
						-1); 
				}
			}
		}
		artistArray = null;
		albumArray = null;
		titleArray = null;
		return false;
	}
		
	private void set_pixbufs() {
		try {
			artist_pixb = new Gdk.Pixbuf.from_file(Config.UIDIR + "/guitar.png");
			album_pixb  = new Gdk.Pixbuf.from_file(Config.UIDIR + "/album.png");
			title_pixb  = new Gdk.Pixbuf.from_file(Config.UIDIR + "/note.png");
		}
		catch (GLib.Error e) {
			print("Error: %s\n",e.message);
		}
	}	

	private void setup_view() {	
		this.set_size_request (300,500);
		var renderer = new CellRendererText();
		renderer.font="Sans 9"; //TODO: This should not be hard wired
		renderer.set_fixed_height_from_font(1);
		var pixbufRenderer = new CellRendererPixbuf();
		pixbufRenderer.stock_id = Gtk.STOCK_GO_FORWARD;
		
		var column = new TreeViewColumn();
		
		column.pack_start(pixbufRenderer, false);
		column.add_attribute(pixbufRenderer, "pixbuf", 0);
		column.pack_start(renderer, false);
		column.add_attribute(renderer, "text", 1); // no markup!!
		this.insert_column(column, -1);
		this.enable_tree_lines = true;
		this.headers_visible = false;
	}
}
