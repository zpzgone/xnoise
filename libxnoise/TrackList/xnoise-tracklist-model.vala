/* xnoise-tracklist-model.vala
 *
 * Copyright (C) 2009-2011  Jörn Magens
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
 * 	Jörn Magens
 */

using Gtk;
using Gdk;

using Xnoise;
using Xnoise.Services;
using Xnoise.TagAccess;

public class Xnoise.TrackListModel : ListStore, TreeModel {

	private Main xn;
	private IconTheme icon_theme;

	public enum Column {
		ICON = 0,
		TRACKNUMBER,
		TITLE,
		ALBUM,
		ARTIST,
		LENGTH,
		WEIGHT,
		GENRE,
		YEAR,
		ITEM
	}

	private GLib.Type[] col_types = new GLib.Type[] {
		typeof(Gdk.Pixbuf),  // ICON
		typeof(string),      // TRACKNUMBER
		typeof(string),      // TITLE
		typeof(string),      // ALBUM
		typeof(string),      // ARTIST
		typeof(string),      // LENGTH
		typeof(int),         // WEIGHT
		typeof(string),      // GENRE
		typeof(string),      // YEAR
		typeof(Xnoise.Item?) // Item
	};

	public signal void sign_active_path_changed(PlayerState ts);

	public TrackListModel() {
		this.xn = Main.instance;
		this.icon_theme = IconTheme.get_default();
		this.set_column_types(col_types);

		// Use these two signals to handle the position_reference representation in tracklist
		global.before_position_reference_changed.connect(on_before_position_reference_changed);
		global.position_reference_changed.connect(on_position_reference_changed);
		global.player_state_changed.connect( () => {
			switch(global.player_state) {
				case PlayerState.PLAYING: {
					this.set_play_state();
					break;
				}
				case PlayerState.PAUSED: {
					this.set_pause_state();
					break;
				}
				case PlayerState.STOPPED: {
					this.reset_state();
					break;
				}
				default: break;
			}
		});
		icon_theme.changed.connect(update_icons); //TODO update icon
	}
	
	private void update_icons() {
	print("update_icons tlm\n");
		//TODO
	}
	
	public Iterator iterator() {
		return new Iterator(this);
	}

	public class Iterator {
		private int index;
		private unowned TrackListModel tlm;

		public Iterator(TrackListModel tlm) {
			this.tlm = tlm;
		}

		public bool next() {
			return true;
		}

		public TreeIter get() {
			TreeIter iter;
			tlm.iter_nth_child(out iter, null, index);
			return iter;
		}
	}

	public void on_before_position_reference_changed() {
		unbolden_row();
		reset_state();
	}

	public bool get_first_row(ref TreePath treepath) {
		int n_children = this.iter_n_children(null);

		if(n_children == 0) {
			return false;
		}
		treepath = new TreePath.from_indices(0);

		if(treepath!=null) return true;

		return false;
	}

	public bool get_random_row(ref TreePath treepath){
		int n_children = this.iter_n_children(null);

		if(n_children <= 1) {
			return false;
		}
		//RANDOM FUNCTION
		var rand = new Rand();
		uint32 rand_val = rand.int_range((int32)0, (int32)(n_children - 1));

		treepath = new TreePath.from_indices((int)rand_val);

		if(treepath!=null)
			return true;

		return false;
	}

	public bool path_is_last_row(ref TreePath path, out bool trackList_is_empty) {
		trackList_is_empty = false;
		int n_children = this.iter_n_children(null);

		if(n_children == 0) {
			trackList_is_empty = true;
			return false; // Here something is wrong
		}

		// create treepath pointing to last row
		var tp = new TreePath.from_indices(n_children - 1);

		if(tp == null) {
			trackList_is_empty = true;
			return false;
		}

		// compare my treepath with last row
		if(path.compare(tp) == 0) return true;
		return false;
	}

	public void on_position_reference_changed() {
		TreePath treepath;
		TreeIter iter;
//		string uri = "";

		// Handle uri stuff
		if(get_current_path(out treepath)) {
			Item? item;
			this.get_iter(out iter, treepath);
			this.get(iter, Column.ITEM, out item);
			if((item.uri != "") && (item.uri == global.current_uri)) {
				global.do_restart_of_current_track();
				global.uri_repeated(item.uri);
			}
			
			if(item.uri != "")
				global.current_uri = item.uri;
			
		}
		else {
			return;
		}

		// Set visual feedback for tracklist
		if(((int)global.player_state) > 0) { //playing or paused
			bolden_row();

			if(global.player_state == PlayerState.PLAYING)
				set_play_state();
			else if(global.player_state== PlayerState.PAUSED)
				set_pause_state();
		}
		else {
			unbolden_row();
			reset_state();
		}
	}

	// gets path global-position_reference is pointing to
	public bool get_current_path(out TreePath treepath) {
		treepath = null;
		if((global.position_reference.valid()&&
		  (global.position_reference != null))) {
			treepath = global.position_reference.get_path();
			if(treepath!=null) {
				// print("active path: " + treepath.to_string() + "\n");
				return true;
			}
			return false;
		}
		return false;
	}

	// gets active path, or first path
	public bool get_active_path(out TreePath treepath, out bool used_next_pos) {
		TreeIter iter;
		used_next_pos = false;
		if((global.position_reference.valid()&&
		  (global.position_reference != null))) {
			treepath = global.position_reference.get_path();
			if(treepath!=null) {
				this.get_iter(out iter, treepath);
				return true;
			}
			return false;
		}
		else if(global.position_reference_next.valid()&&
		  (global.position_reference_next != null)) {
			//print("use position_reference_next \n");
			used_next_pos = true;
			global.position_reference = global.position_reference_next;
			treepath = global.position_reference.get_path();
			if(treepath!=null) {
				this.get_iter(out iter, treepath);
				return true;
			}
			return false;
		}
		else if(this.get_iter_first(out iter)) {
			treepath = this.get_path(iter);
			used_next_pos = true;

			if(treepath != null)
				global.position_reference_next = new TreeRowReference(this, treepath);

			return true;
		}
		global.position_reference = null;
		global.position_reference_next = null;
		return false;
	}

	public TreeIter insert_title(Gdk.Pixbuf? pixbuf,
	                             ref TrackData td,
	                             bool bold = false) {
		TreeIter iter;
		int int_bold = Pango.Weight.NORMAL;
		string? tracknumberString = null;
		string? lengthString = null;
		string? yearString = null;
		this.append(out iter);
		
		if(!(td.tracknumber==0))
			tracknumberString = "%u".printf(td.tracknumber);
		
		if(td.length > 0) {
			// convert seconds to a user convenient mm:ss display
			int dur_min, dur_sec;
			dur_min = (int)(td.length / 60);
			dur_sec = (int)(td.length % 60);
			lengthString = "%02d:%02d".printf(dur_min, dur_sec);
		}
		if(td.year > 0) {
			yearString = "%u".printf(td.year);
		}
		if(bold)
			int_bold = Pango.Weight.BOLD;
		else
			int_bold = Pango.Weight.NORMAL;
		
		this.set(iter,
		         TrackListModel.Column.ITEM ,td.item,
		         TrackListModel.Column.ICON, pixbuf,
		         TrackListModel.Column.TRACKNUMBER, tracknumberString,
		         TrackListModel.Column.TITLE, td.title,
		         TrackListModel.Column.ALBUM, td.album,
		         TrackListModel.Column.ARTIST, td.artist,
		         TrackListModel.Column.LENGTH, lengthString,
		         TrackListModel.Column.WEIGHT, int_bold,
		         TrackListModel.Column.YEAR, yearString,
		         TrackListModel.Column.GENRE, td.genre
		         );
		return iter;
	}

	public bool not_empty() {
		if(this.iter_n_children(null) > 0)
			return true;
		else
			return false;
	}

	public void set_reference_to_last() {
		TreeIter iter;
		int numberOfRows = 0;
		numberOfRows = this.iter_n_children(null);

		if(numberOfRows == 0) return;

		this.iter_nth_child(out iter, null, numberOfRows -1);
		var tpath = this.get_path(iter);

		if(tpath == null) return;

		// if reference is null and reference_next is pointing to a row,
		// reference _next shall be used
		global.position_reference = null;
		global.position_reference_next = new TreeRowReference(this, tpath);
	}

	// used for saving current tracks in list before quit
	public Item[] get_all_tracks() {
		list_of_items = {};
		this.foreach(list_foreach);
		return list_of_items;
	}

	private Item[] list_of_items;
	private bool list_foreach(TreeModel sender, TreePath path, TreeIter iter) {
		Item? item = null;
		sender.get(iter, Column.ITEM, out item);
		if(item == null)
			return false;
		list_of_items += item;
		return false;
	}

	public string get_uri_for_current_position() {
//		string uri = "";
		TreeIter iter;
		Item? item = Item(ItemType.UNKNOWN);
		if((global.position_reference != null)&&
		   (global.position_reference.valid())) {
		// Use position_reference, if available...
			this.get_iter(out iter, global.position_reference.get_path());
			this.get(iter, Column.ITEM, out item);
		}
		else if((global.position_reference != null)&&
		   (global.position_reference.valid())) {
		// ...or use position_reference_next, if available
			this.get_iter(out iter, global.position_reference_next.get_path());
			this.get(iter, Column.ITEM, out item);
		}
		else if(this.get_iter_first(out iter)){
			// ... or use first position, if available and 
			// set global.position_reference to that track
			this.get(iter, Column.ITEM, out item);
			global.position_reference = null;
			global.position_reference = new TreeRowReference(this, this.get_path(iter));
		}
		return item.uri;
	}

	// find active row, set state picture, bolden and set uri for gpl
	private bool set_player_state(PlayerState ts) {
		Gdk.Pixbuf? pixbuf = null;
		Gtk.Invisible w = new Gtk.Invisible();
		if((global.position_reference == null)||
		  (!global.position_reference.valid())) {
/*
			print("current position not found, use _next\n");
			global.position_reference = global.position_reference_next;
*/
			return false;
		}
		TreeIter citer;
		this.get_iter(out citer, global.position_reference.get_path());
//		string xuri;
		if(ts==PlayerState.PLAYING) {
			bolden_row();
			pixbuf = w.render_icon(Gtk.Stock.MEDIA_PLAY, IconSize.BUTTON, null);
		}
		else if(ts==PlayerState.PAUSED) {
			bolden_row();
			pixbuf = w.render_icon(Gtk.Stock.MEDIA_PAUSE, IconSize.BUTTON, null);
		}
		else if(ts==PlayerState.STOPPED) {
			unbolden_row();
			this.set(citer, Column.ICON, null);
			return true;
		}
		Item? item;
		this.get(citer,
				 Column.ITEM, out item
				 );
		if(item.uri == gst_player.uri) {
			this.set(citer, Column.ICON, pixbuf);
		}
		return true;
	}

	public bool reset_state() {
		return set_player_state(PlayerState.STOPPED);
	}

	private bool set_play_state() {
		return set_player_state(PlayerState.PLAYING);
	}

	private bool set_pause_state() {
		return set_player_state(PlayerState.PAUSED);
	}

	private void bolden_row() {
		if(global.position_reference == null) return;
		if(!global.position_reference.valid()) return;

		var tpath = global.position_reference.get_path();

		if(tpath == null) return;

		TreeIter citer;
		this.get_iter(out citer, tpath);

		this.set(citer,
		         Column.WEIGHT, Pango.Weight.BOLD,
		         -1);
	}

	private void unbolden_row() {
		if(global.position_reference == null) return;
		if(!global.position_reference.valid()) return;

		var tpath = global.position_reference.get_path();

		if(tpath == null) return;

		TreeIter citer;
		this.get_iter(out citer, tpath);
		this.set(citer,
		         Column.WEIGHT, Pango.Weight.NORMAL,
		         -1);
	}

	public void add_uris(string[]? uris) {
		if(uris == null) return;
		if(uris[0] == null) return;
		int k = 0;
		TreeIter iter, iter_2;
		FileType filetype;
		this.get_iter_first(out iter_2);
		Item? item = Item(ItemType.UNKNOWN);
		while(uris[k] != null) { //because foreach is not working for this array coming from libunique
			File file = File.new_for_uri(uris[k]);
			TagReader tr = new TagReader();
			bool is_stream = false;
			string urischeme = file.get_uri_scheme();
			var td = new TrackData();
			if(urischeme in get_local_schemes()) {
				try {
					FileInfo info = file.query_info(FILE_ATTRIBUTE_STANDARD_TYPE,
				                                    FileQueryInfoFlags.NONE,
				                                    null);
					filetype = info.get_file_type();
				}
				catch(GLib.Error e) {
					print("%s\n", e.message);
					k++;
					continue;
				}
				if(filetype == GLib.FileType.REGULAR) {
					td = tr.read_tag(file.get_path()); // move to worker thread
				}
				else {
					is_stream = true;
				}
			}
			else if(urischeme in get_remote_schemes()) {
				is_stream = true;
			}
			item = ItemHandlerManager.create_item(uris[k]);
			if(k == 0) { // first track
				iter = this.insert_title(null,
				                         ref td,
				                         true);
				
				global.position_reference = null; // TODO: Is this necessary???
				global.position_reference = new TreeRowReference(this, this.get_path(iter));
				iter_2 = iter;
			}
			else {
				td.item = ItemHandlerManager.create_item(uris[k]);
				iter = this.insert_title(null,
				                         ref td,
				                         false);
			}
			tr = null;
			k++;
		}
		if(item.type != ItemType.UNKNOWN) { // TODO ????
			ItemHandler? tmp = itemhandler_manager.get_handler_by_type(ItemHandlerType.PLAY_NOW);
			if(tmp == null)
				return;
			unowned Action? action = tmp.get_action(item.type, ActionContext.REQUESTED, ItemSelectionType.SINGLE);
			if(action != null)
				action.action(item, null);
		}
		tl.set_focus_on_iter(ref iter_2);
	}
}