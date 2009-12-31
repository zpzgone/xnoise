/* xnoise-1.0.vapi generated by valac, do not modify. */

[CCode (cprefix = "Gst", lower_case_cprefix = "gst_")]
namespace Gst {
	[CCode (cprefix = "GST_STREAM_TYPE_", cheader_filename = "xnoise.h")]
	public enum StreamType {
		UNKNOWN,
		AUDIO,
		VIDEO
	}
}
[CCode (cprefix = "Xnoise", lower_case_cprefix = "xnoise_")]
namespace Xnoise {
	[CCode (cheader_filename = "xnoise.h")]
	public class AboutDialog : Gtk.AboutDialog {
		public AboutDialog ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class AddMediaDialog : GLib.Object {
		public Gtk.Builder builder;
		public AddMediaDialog ();
		public signal void sign_finish ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class AlbumImage : Gtk.Fixed {
		public Gtk.Image albumimage;
		public AlbumImage ();
		public void load_default_image ();
		public bool album_image_available { get; set; }
		public string current_image_path { get; set; }
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class AlbumImageLoader : GLib.Object {
		[CCode (cheader_filename = "xnoise.h")]
		public delegate Xnoise.IAlbumCoverImage AlbumImageCreatorDelg (string artist, string album);
		public Xnoise.IAlbumCoverImage album_image_provider;
		public AlbumImageLoader (string artist, string album);
		public bool fetch_image ();
		public string get_image_uri ();
		public static void init ();
		public signal void sign_fetched (string? image_path);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class AppStarter : GLib.Object {
		public static Xnoise.Main xn;
		public AppStarter ();
		public static int main (string[] args);
		public static Unique.Response on_message_received (Unique.App sender, int command, Unique.MessageData message_data, uint time);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class DbBrowser : GLib.Object {
		public DbBrowser ();
		public string[] get_albums (string artist, ref string searchtext);
		public string[] get_artists (ref string searchtext);
		public string[] get_lastused_uris ();
		public string? get_local_image_path_for_uri (ref string uri);
		public string[] get_media_files ();
		public string[] get_media_folders ();
		public string? get_single_stream_uri (string name);
		public Xnoise.TitleMtypeId[] get_stream_data (ref string searchtext);
		public bool get_stream_for_id (int id, out string uri);
		public bool get_stream_td_for_id (int id, out Xnoise.TrackData val);
		public Xnoise.StreamData[] get_streams ();
		public Xnoise.TitleMtypeId[] get_titles_with_mediatypes_and_ids (string artist, string album, ref string searchtext);
		public int get_track_id_for_path (string uri);
		public bool get_trackdata_for_id (int id, out Xnoise.TrackData val);
		public bool get_trackdata_for_stream (string uri, out Xnoise.TrackData val);
		public bool get_trackdata_for_uri (string uri, out Xnoise.TrackData val);
		public bool get_uri_for_id (int id, out string val);
		public Xnoise.TitleMtypeId[] get_video_data (ref string searchtext);
		public string[] get_videos (ref string searchtext);
		public bool stream_is_in_db (string uri);
		public bool streams_available ();
		public bool uri_is_in_db (string uri);
		public bool videos_available ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class DbCreator : GLib.Object {
		public const int DB_VERSION_MAJOR;
		public const int DB_VERSION_MINOR;
		public DbCreator ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class DbWriter : GLib.Object {
		public DbWriter ();
		public bool set_local_image_for_album (ref string artist, ref string album, string image_uri);
		public void store_media_files (string[] list_of_files);
		public void store_media_folders (string[] mfolders);
		public void store_streams (string[] list_of_streams);
		public void write_final_tracks_to_db (string[] final_tracklist);
		public signal void sign_import_progress (uint current, uint amount);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class GlobalData : GLib.Object {
		public GlobalData ();
		public void handle_eos ();
		public string current_uri { get; set; }
		public Gtk.TreeRowReference next_position_reference { get; set; }
		public Gtk.TreeRowReference position_reference { get; set; }
		public Xnoise.TrackState track_state { get; set; }
		public signal void before_position_reference_changed ();
		public signal void caught_eos_from_player ();
		public signal void current_uri_changed ();
		public signal void position_reference_changed ();
		public signal void track_state_changed ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class GstPlayer : GLib.Object {
		public Gst.Element playbin;
		public Xnoise.VideoScreen videoscreen;
		public GstPlayer ();
		public void pause ();
		public void play ();
		public void playSong (bool force_play = false);
		public void stop ();
		public string Uri { get; set; }
		public bool current_has_video { get; set; }
		public string currentalbum { get; set; }
		public string currentartist { get; set; }
		public string currentgenre { get; set; }
		public string currentlocation { get; set; }
		public string currentorg { get; set; }
		public string currenttitle { get; set; }
		public double gst_position { set; }
		public bool is_stream { get; set; }
		public int64 length_time { get; set; }
		public bool paused { get; set; }
		public bool playing { get; set; }
		public bool seeking { get; set; }
		public Gst.TagList taglist { get; set; }
		public double volume { get; set; }
		public signal void sign_paused ();
		public signal void sign_playing ();
		public signal void sign_song_position_changed (uint msecs, uint ms_total);
		public signal void sign_stopped ();
		public signal void sign_tag_changed (string newuri);
		public signal void sign_uri_changed (string newuri);
		public signal void sign_video_playing ();
		public signal void sign_volume_changed (double volume);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class LyricsLoader : GLib.Object {
		[CCode (cheader_filename = "xnoise.h")]
		public delegate Xnoise.ILyrics LyricsCreatorDelg (string artist, string title);
		public string artist;
		public Xnoise.ILyrics lyrics;
		public string title;
		public LyricsLoader (string artist, string title);
		public bool fetch ();
		public string get_text ();
		public static void init ();
		public signal void sign_fetched (string provider, string content);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class LyricsView : Gtk.TextView {
		public LyricsView ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class Main : GLib.Object {
		public Xnoise.GstPlayer gPl;
		public Xnoise.MainWindow main_window;
		public Xnoise.PluginLoader plugin_loader;
		public Xnoise.TrackList tl;
		public Xnoise.TrackListModel tlm;
		public Main ();
		public void add_track_to_gst_player (string uri);
		public static Xnoise.Main instance ();
		public void quit ();
		public void save_tracklist ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class MainWindow : Gtk.Window, Xnoise.IParams {
		[CCode (cheader_filename = "xnoise.h")]
		public class NextButton : Gtk.Button {
			public NextButton ();
			public void on_clicked ();
		}
		[CCode (cheader_filename = "xnoise.h")]
		public class PlayPauseButton : Gtk.Button {
			public PlayPauseButton ();
			public void on_clicked (Gtk.Widget sender);
			public void on_menu_clicked (Gtk.MenuItem sender);
			public void set_pause_picture ();
			public void set_play_picture ();
			public void update_picture ();
		}
		[CCode (cheader_filename = "xnoise.h")]
		public class PreviousButton : Gtk.Button {
			public PreviousButton ();
			public void on_clicked ();
		}
		[CCode (cheader_filename = "xnoise.h")]
		public class SongProgressBar : Gtk.ProgressBar {
			public SongProgressBar ();
			public void set_value (uint pos, uint len);
		}
		[CCode (cheader_filename = "xnoise.h")]
		public class StopButton : Gtk.Button {
			public StopButton ();
		}
		[CCode (cheader_filename = "xnoise.h")]
		public class VolumeSliderButton : Gtk.VolumeButton {
			public VolumeSliderButton ();
		}
		public bool _seek;
		public Xnoise.AlbumImage albumimage;
		public Gtk.Notebook browsernotebook;
		public double current_volume;
		public bool drag_on_da;
		public Gtk.Window fullscreenwindow;
		public bool is_fullscreen;
		public Xnoise.LyricsView lyricsView;
		public Xnoise.MediaBrowser mediaBr;
		public Xnoise.MainWindow.NextButton nextButton;
		public Xnoise.MainWindow.PlayPauseButton playPauseButton;
		public Gtk.Image playpause_popup_image;
		public Xnoise.MainWindow.PreviousButton previousButton;
		public Gtk.Button repeatButton01;
		public Gtk.Button repeatButton02;
		public Gtk.Button repeatButton03;
		public Gtk.Image repeatImage01;
		public Gtk.Image repeatImage02;
		public Gtk.Image repeatImage03;
		public Gtk.Label repeatLabel01;
		public Gtk.Label repeatLabel02;
		public Gtk.Label repeatLabel03;
		public Gtk.Entry searchEntryMB;
		public Xnoise.MainWindow.SongProgressBar songProgressBar;
		public Xnoise.MainWindow.StopButton stopButton;
		public Xnoise.TrackList trackList;
		public Gtk.Notebook tracklistnotebook;
		public Xnoise.VideoScreen videoscreen;
		public MainWindow (ref unowned Xnoise.Main xn);
		public void change_song (Xnoise.Direction direction, bool handle_repeat_state = false);
		public Gtk.UIManager get_ui_manager ();
		public void set_displayed_title (string newuri);
		public bool fullscreenwindowvisible { get; set; }
		public int repeatState { get; set; }
		public signal void sign_drag_over_da ();
		public signal void sign_pos_changed (double fraction);
		public signal void sign_volume_changed (double fraction);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class MediaBrowser : Gtk.TreeView, Xnoise.IParams {
		public Xnoise.MediaBrowserModel mediabrowsermodel;
		public MediaBrowser (ref unowned Xnoise.Main xn);
		public bool change_model_data ();
		public void on_searchtext_changed (Gtk.Editable sender);
		public signal void sign_activated ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class MediaBrowserModel : Gtk.TreeStore, Gtk.TreeModel {
		public string searchtext;
		public MediaBrowserModel ();
		public string[] build_uri_list_for_treepath (Gtk.TreePath treepath, ref Xnoise.DbBrowser dbb);
		public Xnoise.TrackData[] get_trackdata_for_treepath (Gtk.TreePath treepath);
		public Xnoise.TrackData[] get_trackdata_hierarchical (Gtk.TreePath treepath);
		public Xnoise.TrackData[] get_trackdata_listed (Gtk.TreePath treepath);
		public bool populate_model ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class Params : GLib.Object {
		public Params ();
		public double get_double_value (string key);
		public int get_int_value (string key);
		public string[]? get_string_list_value (string key);
		public string get_string_value (string key);
		public void iparams_register (Xnoise.IParams iparam);
		public void set_double_value (string key, double value);
		public void set_int_value (string key, int value);
		public void set_start_parameters_in_implementors ();
		public void set_string_list_value (string key, string[]? value);
		public void set_string_value (string key, string value);
		public void write_all_parameters_to_file ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class Plugin : GLib.Object {
		public GLib.Object loaded_plugin;
		public Plugin (Xnoise.PluginInformation info);
		public bool load (ref unowned Xnoise.Main xn);
		public Gtk.Widget? settingwidget ();
		public bool activated { get; set; }
		public bool configurable { get; set; }
		public bool is_album_image_plugin { get; set; }
		public bool is_lyrics_plugin { get; set; }
		public bool loaded { get; set; }
		public signal void sign_activated ();
		public signal void sign_deactivated ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class PluginInformation : GLib.Object {
		public PluginInformation (string xplug_file);
		public bool load_info ();
		public string author { get; set; }
		public string copyright { get; set; }
		public string description { get; set; }
		public string icon { get; set; }
		public string license { get; set; }
		public string module { get; set; }
		public string name { get; set; }
		public string website { get; set; }
		public string xplug_file { get; set; }
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class PluginLoader : GLib.Object {
		public GLib.HashTable<string,Xnoise.Plugin> lyrics_plugins_htable;
		public GLib.HashTable<string,Xnoise.Plugin> plugin_htable;
		public PluginLoader (ref unowned Xnoise.Main xn);
		public bool activate_single_plugin (string name);
		public void deactivate_single_plugin (string name);
		public unowned GLib.List<string> get_info_files ();
		public bool load_all ();
		public signal void sign_plugin_activated (Xnoise.Plugin p);
		public signal void sign_plugin_deactivated (Xnoise.Plugin p);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class PluginManagerTree : Gtk.TreeView {
		public PluginManagerTree (ref Xnoise.Main xn);
		public void create_view ();
		public signal void sign_plugin_activestate_changed (string name);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class SettingsDialog : Gtk.Builder {
		public Gtk.Dialog dialog;
		public SettingsDialog (ref Xnoise.Main xn);
		public signal void sign_finish ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class TagReader : GLib.Object {
		public TagReader ();
		public Xnoise.TrackData read_tag (string filename);
	}
	[CCode (ref_function = "xnoise_track_data_ref", unref_function = "xnoise_track_data_unref", cheader_filename = "xnoise.h")]
	public class TrackData {
		public string Album;
		public string Artist;
		public string Genre;
		public Xnoise.MediaType Mediatype;
		public string Title;
		public uint Tracknumber;
		public string Uri;
		public uint Year;
		public TrackData ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class TrackList : Gtk.TreeView {
		public Xnoise.TrackListModel tracklistmodel;
		public TrackList ();
		public string get_uri_for_current_position ();
		public void on_activated (string uri, Gtk.TreePath path);
		public void remove_selected_rows ();
		public void set_focus_on_iter (ref Gtk.TreeIter iter);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class TrackListModel : Gtk.ListStore, Gtk.TreeModel {
		public TrackListModel ();
		public void add_tracks (Xnoise.TrackData[]? td_list, bool imediate_play = true);
		public void add_uris (string[]? uris);
		public bool get_active_path (out Gtk.TreePath treepath, out Xnoise.TrackState currentstate, out bool is_first);
		public string[] get_all_tracks ();
		public Gtk.TreeIter insert_title (Xnoise.TrackState status = Xnoise.TrackState.STOPPED, Gdk.Pixbuf? pixbuf, int tracknumber, string title, string album, string artist, bool bold = false, string uri);
		public void mark_last_title_active ();
		public bool not_empty ();
		public void on_before_position_reference_changed ();
		public void on_position_reference_changed ();
		public bool set_play_state_for_first_song ();
		public void set_state_picture_for_title (Gtk.TreeIter iter, Xnoise.TrackState state = Xnoise.TrackState.STOPPED);
		public signal void sign_active_path_changed (Xnoise.TrackState ts);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class VideoScreen : Gtk.DrawingArea {
		public Gdk.Pixbuf logo_pixb;
		public VideoScreen ();
		public override bool expose_event (Gdk.EventExpose e);
		public void trigger_expose ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface IAlbumCoverImage : GLib.Object {
		public abstract void* fetch_image ();
		public abstract string get_image_uri ();
		public signal void sign_album_image_done (Xnoise.IAlbumCoverImage instance);
		public signal void sign_album_image_fetched (string? image_path);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface IAlbumCoverImageProvider : GLib.Object {
		public abstract Xnoise.IAlbumCoverImage from_tags (string artist, string album);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface ILyrics : GLib.Object {
		public abstract void* fetch ();
		public abstract string get_credits ();
		public abstract string get_identifier ();
		public abstract string get_text ();
		public signal void sign_lyrics_done (Xnoise.ILyrics instance);
		public signal void sign_lyrics_fetched (string text);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface ILyricsProvider : GLib.Object {
		public abstract Xnoise.ILyrics from_tags (string artist, string title);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface IParams : GLib.Object {
		public abstract void read_params_data ();
		public abstract void write_params_data ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface IPlugin : GLib.Object {
		public abstract Gtk.Widget? get_settings_widget ();
		public abstract bool has_settings_widget ();
		public abstract bool init ();
		public abstract string name { get; }
		public abstract Xnoise.Main xn { get; set; }
	}
	[CCode (type_id = "XNOISE_TYPE_STREAM_DATA", cheader_filename = "xnoise.h")]
	public struct StreamData {
		public string Name;
		public string Uri;
	}
	[CCode (type_id = "XNOISE_TYPE_TITLE_MTYPE_ID", cheader_filename = "xnoise.h")]
	public struct TitleMtypeId {
		public string name;
		public int id;
		public Xnoise.MediaType mediatype;
	}
	[CCode (cprefix = "XNOISE_BROWSER_COLLECTION_TYPE_", cheader_filename = "xnoise.h")]
	public enum BrowserCollectionType {
		UNKNOWN,
		HIERARCHICAL,
		LISTED
	}
	[CCode (cprefix = "XNOISE_BROWSER_COLUMN_", cheader_filename = "xnoise.h")]
	public enum BrowserColumn {
		ICON,
		VIS_TEXT,
		DB_ID,
		MEDIATYPE,
		COLL_TYPE,
		DRAW_SEPTR,
		N_COLUMNS
	}
	[CCode (cprefix = "XNOISE_DIRECTION_", cheader_filename = "xnoise.h")]
	public enum Direction {
		NEXT,
		PREVIOUS
	}
	[CCode (cprefix = "XNOISE_MEDIA_STORAGE_TYPE_", cheader_filename = "xnoise.h")]
	public enum MediaStorageType {
		FILE,
		FOLDER,
		STREAM
	}
	[CCode (cprefix = "XNOISE_MEDIA_TYPE_", cheader_filename = "xnoise.h")]
	public enum MediaType {
		UNKNOWN,
		AUDIO,
		VIDEO,
		STREAM,
		PLAYLISTFILE
	}
	[CCode (cprefix = "XNOISE_REPEAT_", cheader_filename = "xnoise.h")]
	public enum Repeat {
		NOT_AT_ALL,
		SINGLE,
		ALL
	}
	[CCode (cprefix = "XNOISE_TRACK_LIST_MODEL_COLUMN_", cheader_filename = "xnoise.h")]
	public enum TrackListModelColumn {
		STATE,
		ICON,
		TRACKNUMBER,
		TITLE,
		ALBUM,
		ARTIST,
		WEIGHT,
		URI,
		N_COLUMNS
	}
	[CCode (cprefix = "XNOISE_TRACK_STATE_", cheader_filename = "xnoise.h")]
	public enum TrackState {
		STOPPED,
		PLAYING,
		PAUSED
	}
	[CCode (cheader_filename = "xnoise.h")]
	public static Xnoise.GlobalData global;
	[CCode (cheader_filename = "xnoise.h")]
	public static Xnoise.Params par;
	[CCode (cheader_filename = "xnoise.h")]
	public static string escape_for_local_folder_search (string value);
	[CCode (cheader_filename = "xnoise.h")]
	public static string get_stream_uri (string playlist_uri);
	[CCode (cheader_filename = "xnoise.h")]
	public static void initialize ();
	[CCode (cheader_filename = "xnoise.h")]
	public static string remove_linebreaks (string value);
}
[CCode (cname = "gdk_window_ensure_native", cheader_filename = "xnoise.h")]
public static bool ensure_native (Gdk.Window window);
