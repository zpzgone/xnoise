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
	public class AlbumImage : Gtk.Image {
		public AlbumImage ();
		public void load_default_image ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class AlbumImageLoader : GLib.Object {
		public string album;
		public string artist;
		public AlbumImageLoader ();
		public bool fetch_image ();
		public signal void sign_fetched (string artist, string album, string image_path);
	}
	[CCode (ref_function = "xnoise_app_starter_ref", unref_function = "xnoise_app_starter_unref", cheader_filename = "xnoise.h")]
	public class AppStarter {
		public static Xnoise.Main xn;
		public AppStarter ();
		public static int main (string[] args);
		public static Unique.Response on_message_received (Unique.App sender, int command, Unique.MessageData message_data, uint time);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class ControlButton : Gtk.Button {
		[CCode (cprefix = "XNOISE_CONTROL_BUTTON_DIRECTION_", cheader_filename = "xnoise.h")]
		public enum Direction {
			NEXT,
			PREVIOUS,
			STOP
		}
		public ControlButton (Xnoise.ControlButton.Direction _direction = Xnoise.ControlButton.Direction.STOP);
		public signal void sign_clicked (Xnoise.ControlButton.Direction dir);
	}
	[CCode (ref_function = "xnoise_db_browser_ref", unref_function = "xnoise_db_browser_unref", cheader_filename = "xnoise.h")]
	public class DbBrowser {
		public DbBrowser () throws GLib.Error;
		public string[] get_albums (string artist, ref string searchtext);
		public string[] get_artists (ref string searchtext);
		public string[] get_lastused_uris ();
		public string? get_local_image_path_for_track (ref string? uri);
		public string[] get_media_files ();
		public string[] get_media_folders ();
		public string? get_single_stream_uri (string name);
		public Xnoise.MediaData[] get_stream_data (ref string searchtext);
		public bool get_stream_for_id (int id, out string uri);
		public bool get_stream_td_for_id (int id, out Xnoise.TrackData val);
		public Xnoise.StreamData[] get_streams ();
		public Xnoise.MediaData[] get_titles_with_mediatypes_and_ids (string artist, string album, ref string searchtext);
		public int get_track_id_for_path (string uri);
		public bool get_trackdata_for_id (int id, out Xnoise.TrackData val);
		public bool get_trackdata_for_stream (string uri, out Xnoise.TrackData val);
		public bool get_trackdata_for_uri (string? uri, out Xnoise.TrackData val);
		public bool get_uri_for_id (int id, out string val);
		public string[] get_uris (string search_string);
		public Xnoise.MediaData[] get_video_data (ref string searchtext);
		public string[] get_videos (ref string searchtext);
		public bool stream_in_db (string uri);
		public bool streams_available ();
		public bool track_in_db (string uri);
		public bool videos_available ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class DbCreator : GLib.Object {
		public const int DB_VERSION_MAJOR;
		public const int DB_VERSION_MINOR;
		public DbCreator () throws GLib.Error;
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class DbWriter : GLib.Object {
		public DbWriter () throws Xnoise.DbError;
		public void add_single_file_to_collection (string uri);
		public void add_single_folder_to_collection (string mfolder);
		public void add_single_stream_to_collection (string uri, string name = "");
		public void begin_transaction ();
		public void commit_transaction ();
		public void del_all_files ();
		public void del_all_folders ();
		public void del_all_streams ();
		public bool delete_local_media_data ();
		public void delete_uri (string uri);
		public void insert_title (Xnoise.TrackData td, string uri);
		public bool set_local_image_for_album (ref string artist, ref string album, string image_path);
		public int uri_entry_exists (string uri);
		public void write_final_tracks_to_db (string[] final_tracklist) throws GLib.Error;
	}
	[CCode (ref_function = "xnoise_fullscreen_toolbar_ref", unref_function = "xnoise_fullscreen_toolbar_unref", cheader_filename = "xnoise.h")]
	public class FullscreenToolbar {
		[CCode (cheader_filename = "xnoise.h")]
		public class LeaveVideoFSButton : Gtk.Button {
			public LeaveVideoFSButton ();
			public void on_clicked ();
		}
		public FullscreenToolbar (Gtk.Window fullscreenwindow);
		public void hide ();
		public void launch_hide_timer ();
		public bool on_pointer_motion (Gdk.EventMotion ev);
		public void resize ();
		public void show ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class GlobalAccess : GLib.Object {
		[CCode (cprefix = "XNOISE_GLOBAL_ACCESS_TRACK_STATE_", cheader_filename = "xnoise.h")]
		public enum TrackState {
			STOPPED,
			PLAYING,
			PAUSED
		}
		public bool _media_import_in_progress;
		public GlobalAccess ();
		public void check_image_for_current_track ();
		public void do_restart_of_current_track ();
		public void handle_eos ();
		public void reset_position_reference ();
		public string? current_album { get; set; }
		public string? current_artist { get; set; }
		public string? current_genre { get; set; }
		public string? current_location { get; set; }
		public string? current_organization { get; set; }
		public string? current_title { get; set; }
		public string? current_uri { get; set; }
		public string? image_path_large { get; set; }
		public string? image_path_small { get; set; }
		public bool media_import_in_progress { get; set; }
		public Gtk.TreeRowReference position_reference { get; set; }
		public Gtk.TreeRowReference position_reference_next { get; set; }
		public string settings_folder { get; }
		public Xnoise.GlobalAccess.TrackState track_state { get; set; }
		public signal void before_position_reference_changed ();
		public signal void before_position_reference_next_changed ();
		public signal void caught_eos_from_player ();
		public signal void position_reference_changed ();
		public signal void position_reference_next_changed ();
		public signal void sig_item_imported (string uri);
		public signal void sig_media_path_changed ();
		public signal void sign_restart_song ();
		public signal void tag_changed (ref string? newuri, string? tagname, string? tagvalue);
		public signal void track_state_changed ();
		public signal void uri_changed (string? uri);
		public signal void uri_repeated (string? uri);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class GstPlayer : GLib.Object {
		public Xnoise.VideoScreen videoscreen;
		public GstPlayer ();
		public void pause ();
		public void play ();
		public void playSong (bool force_play = false);
		public void stop ();
		public string? Uri { get; set; }
		public bool buffering { get; set; }
		public bool current_has_video { get; set; }
		public double gst_position { get; set; }
		public bool is_stream { get; set; }
		public int64 length_time { get; set; }
		public bool paused { get; set; }
		public bool playing { get; set; }
		public bool seeking { get; set; }
		public double volume { get; set; }
		public signal void sign_buffering (int percent);
		public signal void sign_paused ();
		public signal void sign_playing ();
		public signal void sign_song_position_changed (uint msecs, uint ms_total);
		public signal void sign_stopped ();
		public signal void sign_video_playing ();
		public signal void sign_volume_changed (double volume);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class InfoBar : Gtk.InfoBar {
		public InfoBar (Xnoise.UserInfo _uinf, Xnoise.UserInfo.ContentClass _content_class, Xnoise.UserInfo.RemovalType _removal_type, uint _current_id, int _appearance_time_seconds, string _info_text = "", bool bold = true, Gtk.Widget? _extra_widget = null);
		public void enable_close_button (bool enable);
		public void update_extra_widget (Gtk.Widget? widget);
		public void update_symbol_widget (Xnoise.UserInfo.ContentClass cc);
		public void update_text (string txt, bool bold = true);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class LyricsLoader : GLib.Object {
		public string artist;
		public string title;
		public LyricsLoader ();
		public bool fetch ();
		public signal void sign_fetched (string artist, string title, string credits, string identifier, string text);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class LyricsView : Gtk.TextView {
		public LyricsView ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class Main : GLib.Object {
		public Xnoise.GstPlayer gPl;
		public Xnoise.MainWindow main_window;
		public static bool no_plugins;
		public Xnoise.PluginLoader plugin_loader;
		public static bool show_plugin_state;
		public Xnoise.TrackList tl;
		public Xnoise.TrackListModel tlm;
		public Main ();
		public void add_track_to_gst_player (string uri);
		public void quit ();
		public void save_tracklist ();
		public static Xnoise.Main instance { get; }
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class MainWindow : Gtk.Window, Xnoise.IParams {
		public bool _seek;
		public Xnoise.AlbumImage albumimage;
		public Gtk.Notebook browsernotebook;
		public Gtk.Button config_button;
		public bool drag_on_content_area;
		public Xnoise.FullscreenToolbar fullscreentoolbar;
		public Gtk.Window fullscreenwindow;
		public Gtk.HPaned hpaned;
		public bool is_fullscreen;
		public Xnoise.LyricsView lyricsView;
		public Xnoise.MediaBrowser mediaBr;
		public Xnoise.ControlButton nextButton;
		public Xnoise.PlayPauseButton playPauseButton;
		public Gtk.Image playpause_popup_image;
		public Xnoise.ControlButton previousButton;
		public Gtk.Entry searchEntryMB;
		public Xnoise.TrackProgressBar songProgressBar;
		public Xnoise.ControlButton stopButton;
		public Xnoise.TrackListNoteBookTab temporary_tab;
		public Xnoise.TrackList trackList;
		public Gtk.Notebook tracklistnotebook;
		public Xnoise.VideoScreen videoscreen;
		public Gtk.VBox videovbox;
		public MainWindow ();
		public void change_track (Xnoise.ControlButton.Direction direction, bool handle_repeat_state = false);
		public void display_info_bar (Gtk.InfoBar bar);
		public Gtk.UIManager get_ui_manager ();
		public void position_config_menu (Gtk.Menu menu, out int x, out int y, out bool push);
		public void set_displayed_title (ref string? newuri, string? tagname, string? tagvalue);
		public void show_status_info (Xnoise.InfoBar bar);
		public void stop ();
		public void toggle_fullscreen ();
		public bool compact_layout { get; set; }
		public bool fullscreenwindowvisible { get; set; }
		public int repeatState { get; set; }
		public signal void sign_drag_over_content_area ();
		public signal void sign_pos_changed (double fraction);
		public signal void sign_volume_changed (double fraction);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class MediaBrowser : Gtk.TreeView, Xnoise.IParams {
		public Xnoise.MediaBrowserModel mediabrowsermodel;
		public MediaBrowser ();
		public bool change_model_data ();
		public void on_searchtext_changed (string? txt);
		public bool use_treelines { get; set; }
		public signal void sign_activated ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class MediaBrowserModel : Gtk.TreeStore, Gtk.TreeModel {
		[CCode (cprefix = "XNOISE_MEDIA_BROWSER_MODEL_COLLECTION_TYPE_", cheader_filename = "xnoise.h")]
		public enum CollectionType {
			UNKNOWN,
			HIERARCHICAL,
			LISTED
		}
		[CCode (cprefix = "XNOISE_MEDIA_BROWSER_MODEL_COLUMN_", cheader_filename = "xnoise.h")]
		public enum Column {
			ICON,
			VIS_TEXT,
			DB_ID,
			MEDIATYPE,
			COLL_TYPE,
			DRAW_SEPTR,
			N_COLUMNS
		}
		public string searchtext;
		public MediaBrowserModel ();
		public string[] build_uri_list_for_treepath (Gtk.TreePath treepath, ref Xnoise.DbBrowser dbb);
		public Xnoise.TrackData[] get_trackdata_for_treepath (Gtk.TreePath treepath);
		public Xnoise.TrackData[] get_trackdata_hierarchical (Gtk.TreePath treepath);
		public Xnoise.TrackData[] get_trackdata_listed (Gtk.TreePath treepath);
		public bool populate_model ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class MediaImporter : GLib.Object {
		public MediaImporter ();
		public int add_local_tags (GLib.File dir, ref Xnoise.DbWriter dbw);
		public void add_single_file (string uri, ref Xnoise.DbWriter dbw);
		public void store_files (string[] list_of_files, ref Xnoise.DbWriter dbw);
		public void store_folders (string[] mfolders, ref Xnoise.DbWriter dbw);
		public void store_streams (string[] list_of_streams, ref Xnoise.DbWriter dbw);
		public signal void sig_media_path_changed ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class Params : GLib.Object {
		public Params ();
		public double get_double_value (string key);
		public int get_image_provider_priority (string name);
		public int get_int_value (string key);
		public int get_lyric_provider_priority (string name);
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
	public class PlayPauseButton : Gtk.Button {
		public PlayPauseButton ();
		public void on_clicked (Gtk.Widget sender);
		public void on_menu_clicked (Gtk.MenuItem sender);
		public void set_pause_picture ();
		public void set_play_picture ();
		public void update_picture ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class Plugin : GLib.TypeModule {
		public GLib.Object loaded_plugin;
		public Plugin (Xnoise.PluginInformation info);
		public void activate ();
		public void deactivate ();
		public override bool load ();
		public Gtk.Widget? settingwidget ();
		public override void unload ();
		public bool activated { get; set; }
		public bool configurable { get; set; }
		public Xnoise.PluginInformation info { get; }
		public bool is_album_image_plugin { get; set; }
		public bool is_lyrics_plugin { get; set; }
		public bool loaded { get; }
		public signal void sign_activated ();
		public signal void sign_deactivated ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class PluginInformation : GLib.Object {
		public PluginInformation (string xplug_file);
		public bool load_info ();
		public string author { get; }
		public string copyright { get; }
		public string description { get; }
		public string icon { get; }
		public string license { get; }
		public string module { get; }
		public string name { get; }
		public string website { get; }
		public string xplug_file { get; }
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class PluginLoader : GLib.Object {
		public GLib.HashTable<string,Xnoise.Plugin> image_provider_htable;
		public GLib.HashTable<string,string> image_provider_priority;
		public GLib.HashTable<string,Xnoise.Plugin> lyrics_plugins_htable;
		public GLib.HashTable<string,string> lyrics_plugins_priority;
		public GLib.HashTable<string,Xnoise.Plugin> plugin_htable;
		public PluginLoader ();
		public bool activate_single_plugin (string name);
		public void deactivate_single_plugin (string name);
		public unowned GLib.List<string> get_info_files ();
		public bool load_all ();
		public signal void sign_plugin_activated (Xnoise.Plugin p);
		public signal void sign_plugin_deactivated (Xnoise.Plugin p);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class PluginManagerTree : Gtk.TreeView {
		public PluginManagerTree ();
		public void create_view ();
		public signal void sign_plugin_activestate_changed (string name);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class SettingsDialog : Gtk.Builder {
		public Gtk.Dialog dialog;
		public SettingsDialog ();
		public signal void sign_finish ();
	}
	[CCode (ref_function = "xnoise_tag_reader_ref", unref_function = "xnoise_tag_reader_unref", cheader_filename = "xnoise.h")]
	public class TagReader {
		public TagReader ();
		public Xnoise.TrackData read_tag (string filename);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class TextColumn : Gtk.TreeViewColumn {
		public TextColumn (string title, Gtk.CellRendererText renderer, Xnoise.TrackListModel.Column col_id);
		public void adjust_width (int width);
		public Xnoise.TrackListModel.Column id { get; }
		public signal void resized (bool grow, int delta, Xnoise.TrackListModel.Column source_id);
	}
	[CCode (ref_function = "xnoise_track_data_ref", unref_function = "xnoise_track_data_unref", cheader_filename = "xnoise.h")]
	public class TrackData {
		public string Album;
		public string Artist;
		public int Bitrate;
		public string Genre;
		public int32 Length;
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
		public void handle_resize ();
		public void on_activated (string uri, Gtk.TreePath path);
		public void remove_selected_rows ();
		public void set_focus_on_iter (ref Gtk.TreeIter iter);
		public bool column_length_visible { get; set; }
		public bool column_tracknumber_visible { get; set; }
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class TrackListModel : Gtk.ListStore, Gtk.TreeModel {
		[CCode (cprefix = "XNOISE_TRACK_LIST_MODEL_COLUMN_", cheader_filename = "xnoise.h")]
		public enum Column {
			ICON,
			TRACKNUMBER,
			TITLE,
			ALBUM,
			ARTIST,
			LENGTH,
			WEIGHT,
			URI
		}
		public TrackListModel ();
		public void add_tracks (Xnoise.TrackData[]? td_list, bool imediate_play = true);
		public void add_uris (string[]? uris);
		public bool get_active_path (out Gtk.TreePath treepath, out bool used_next_pos);
		public string[] get_all_tracks ();
		public bool get_current_path (out Gtk.TreePath treepath);
		public bool get_first_row (ref Gtk.TreePath treepath);
		public bool get_random_row (ref Gtk.TreePath treepath);
		public string get_uri_for_current_position ();
		public Gtk.TreeIter insert_title (Gdk.Pixbuf? pixbuf, int tracknumber, string title, string album, string artist, int length = 0, bool bold = false, string uri);
		public bool not_empty ();
		public void on_before_position_reference_changed ();
		public void on_position_reference_changed ();
		public bool path_is_last_row (ref Gtk.TreePath path, out bool trackList_is_empty);
		public void set_reference_to_last ();
		public signal void sign_active_path_changed (Xnoise.GlobalAccess.TrackState ts);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class TrackProgressBar : Gtk.ProgressBar {
		public TrackProgressBar ();
		public void set_value (uint pos, uint len);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class UserInfo : GLib.Object {
		[CCode (cprefix = "XNOISE_USER_INFO_CONTENT_CLASS_", cheader_filename = "xnoise.h")]
		public enum ContentClass {
			INFO,
			WAIT,
			WARNING,
			QUESTION,
			CRITICAL
		}
		[CCode (cprefix = "XNOISE_USER_INFO_REMOVAL_TYPE_", cheader_filename = "xnoise.h")]
		public enum RemovalType {
			CLOSE_BUTTON,
			TIMER,
			EXTERNAL
		}
		[CCode (cheader_filename = "xnoise.h")]
		public delegate void AddInfoBarDelegateType (Xnoise.InfoBar ibar);
		public UserInfo (Xnoise.UserInfo.AddInfoBarDelegateType func);
		public void enable_close_button_by_id (uint id, bool enable);
		public void popdown (uint id);
		public uint popup (Xnoise.UserInfo.RemovalType removal_type, Xnoise.UserInfo.ContentClass content_class, string info_text = "", bool bold = true, int appearance_time_seconds = 2, Gtk.Widget? extra_widget = null);
		public void update_extra_widget_by_id (uint id, Gtk.Widget? widget);
		public void update_symbol_widget_by_id (uint id, Xnoise.UserInfo.ContentClass cc);
		public void update_text_by_id (uint id, string txt, bool bold = true);
		public signal void sign_removed_info_bar (uint id);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class VideoScreen : Gtk.DrawingArea {
		public VideoScreen ();
		public override bool expose_event (Gdk.EventExpose e);
		public void trigger_expose ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public class VolumeSliderButton : Gtk.VolumeButton {
		public VolumeSliderButton ();
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface IAlbumCoverImage : GLib.Object {
		public abstract void find_image ();
		public signal void sign_image_fetched (string artist, string album, string image_path);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface IAlbumCoverImageProvider : GLib.Object {
		public abstract Xnoise.IAlbumCoverImage from_tags (string artist, string album);
	}
	[CCode (cheader_filename = "xnoise.h")]
	public interface ILyrics : GLib.Object {
		public abstract void find_lyrics ();
		public abstract string get_credits ();
		public abstract string get_identifier ();
		public signal void sign_lyrics_fetched (string artist, string title, string credits, string identifier, string text);
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
		public abstract Gtk.Widget? get_singleline_settings_widget ();
		public abstract bool has_settings_widget ();
		public abstract bool has_singleline_settings_widget ();
		public abstract bool init ();
		public abstract string name { get; }
		public abstract Xnoise.Main xn { get; set; }
	}
	[CCode (type_id = "XNOISE_TYPE_MEDIA_DATA", cheader_filename = "xnoise.h")]
	public struct MediaData {
		public string name;
		public int id;
		public Xnoise.MediaType mediatype;
	}
	[CCode (type_id = "XNOISE_TYPE_STREAM_DATA", cheader_filename = "xnoise.h")]
	public struct StreamData {
		public string Name;
		public string Uri;
	}
	[CCode (cprefix = "XNOISE_MEDIA_TYPE_", cheader_filename = "xnoise.h")]
	public enum MediaType {
		UNKNOWN,
		AUDIO,
		VIDEO,
		STREAM,
		PLAYLISTFILE
	}
	[CCode (cprefix = "XNOISE_TRACK_LIST_NOTE_BOOK_TAB_", cheader_filename = "xnoise.h")]
	public enum TrackListNoteBookTab {
		TRACKLIST,
		VIDEO,
		LYRICS
	}
	[CCode (cprefix = "XNOISE_DB_ERROR_", cheader_filename = "xnoise.h")]
	public errordomain DbError {
		FAILED,
	}
	[CCode (cprefix = "XNOISE_SETTINGS_DIALOG_ERROR_", cheader_filename = "xnoise.h")]
	public errordomain SettingsDialogError {
		FILE_NOT_FOUND,
		GENERAL_ERROR,
	}
	[CCode (cheader_filename = "xnoise.h")]
	public static Xnoise.GlobalAccess global;
	[CCode (cheader_filename = "xnoise.h")]
	public static Xnoise.Params par;
	[CCode (cheader_filename = "xnoise.h")]
	public static Xnoise.UserInfo userinfo;
	[CCode (cheader_filename = "xnoise.h")]
	public static string escape_for_local_folder_search (string? value);
	[CCode (cheader_filename = "xnoise.h")]
	public static bool get_image_path_for_media_uri (string? uri, ref string? image_path);
	[CCode (cheader_filename = "xnoise.h")]
	public static string get_stream_uri (string playlist_uri);
	[CCode (cheader_filename = "xnoise.h")]
	public static void initialize ();
	[CCode (cheader_filename = "xnoise.h")]
	public static string prepare_for_comparison (string value);
	[CCode (cheader_filename = "xnoise.h")]
	public static string remove_linebreaks (string? value);
	[CCode (cheader_filename = "xnoise.h")]
	public static string remove_single_character (string haystack, string needle);
	[CCode (cheader_filename = "xnoise.h")]
	public static string replace_underline_with_blank_encoded (string value);
}
[CCode (cname = "gdk_window_ensure_native", cheader_filename = "xnoise.h")]
public static bool ensure_native (Gdk.Window window);
