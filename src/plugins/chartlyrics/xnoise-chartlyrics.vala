/* xnoise-chartlyrics.vala
 *
 * Copyright (C) 2009  softshaker
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
 * 	sotshaker
 */
 
// Plugin for chartlyrics.com plugin API


using GLib;
using Soup;
using Xml;

// XML PARSING DOES NOT YET WORK

public class LyricsChartlyrics : GLib.Object, Xnoise.Lyrics {

	private static Session session;
	private Message hid_msg;
	
	private string artist;
	private string title;
		
	private static const string my_identifier= "Chartlyrics";
	private static const string auth = "xnoise";
	private static const string check_url = "http://api.chartlyrics.com/apiv1.asmx/SearchLyric?artist=%s&song=%s";
	private static const string text_url = "http://api.chartlyrics.com/apiv1.asmx/GetLyric?lyricId=%s&lyricCheckSum=%s";
	private static const string xp_hid = "//SearchLyricResult[LyricId != \"\" and LyricChecksum != \"\"]/LyricChecksum";
	private static const string xp_id = "//SearchLyricResult[LyricId != \"\" and LyricChecksum != \"\"]/LyricId";
	private static const string xp_text = "//Lyric";
	
	private static bool _is_initialized = false;
	
	private string hid;
	private string id;
	private string text;
	private bool? availability;
	
	public signal void sign_lyrics_fetched(string text);
	
	
	public LyricsChartlyrics(string artist, string title) {
		if (_is_initialized == false) {
			message ("initting");
			session = new SessionAsync();
			Xml.Parser.init ();
			
			_is_initialized = true;
		}
		
		hid = "";
		id = "";
		
		this.artist = artist;
		this.title = title;
		availability = null;
		
		var gethid_str = new StringBuilder();
		gethid_str.printf(check_url, Soup.URI.encode(artist, null), Soup.URI.encode(title, null));
		//gethid_str.assign (gethid_str.str);
		
		session = new SessionAsync();
		print("%s\n\n", gethid_str.str);
		hid_msg = new Message("GET", gethid_str.str);
	}
	
	
	public static Xnoise.Lyrics from_tags(string artist, string title) {
		return new LyricsChartlyrics(artist, title);
	}
	
	
	public bool fetch_hid() {
		uint status;
		status = session.send_message (hid_msg);
		if (status != KnownStatusCode.OK) return false;
		if (hid_msg.response_body.data == null) return false;
		
		print("-------------------HID\n%s\n\n", hid);
		message(hid_msg.response_body.data);
		
		// Web API call ok, do the xml processing
		
		Xml.Doc* xmldoc = Xml.Parser.read_doc(hid_msg.response_body.data);
		if (xmldoc == null) return false;
		
		XPathContext xp_cont = new XPathContext(xmldoc);
		message(xp_hid);
		var xp_result = xp_cont.eval_expression (xp_hid);
		if (xp_result->nodesetval->is_empty()) { 
			delete xmldoc;
			availability = false;
			return false;
		}
		
		var hid_result_node = xp_result->nodesetval->item (0);
		if (hid_result_node == null) {
			delete xmldoc;
			availability = false;
			return false;
		}
		
		xp_result = xp_cont.eval_expression (xp_id);
		if (xp_result->nodesetval->is_empty()) { 
			delete xmldoc;
			availability = false;
			return false;
		}
		
		hid = hid_result_node->get_content();
		message(hid);
		
		var id_result_node = xp_result->nodesetval->item (0);
		if (hid_result_node == null) {
			delete xmldoc;
			availability = false;
			return false;
		}
		message(id);

		id = id_result_node->get_content();
		delete xmldoc;
		
		if (hid == "" || id == "") {
			availability = false;
			return false;
		}
		
		availability = true;
		return true;
	}
	
	
	public bool fetch_text() {
		var gettext_str = new StringBuilder();
		gettext_str.printf(text_url, id, hid);
		var text_msg = new Message("GET", gettext_str.str);
		
		uint status;
		status = session.send_message (text_msg);
		
		if (status != KnownStatusCode.OK) return false;
		if (text_msg.response_body.data == null) return false;

		// Web API call ok, do the xml processing
		
		Xml.Doc* xmldoc = Xml.Parser.read_doc(text_msg.response_body.data);
		if (xmldoc == null) return false;
		
		XPathContext xp_cont = new XPathContext(xmldoc);
		
		var xp_result = xp_cont.eval_expression(xp_text);
		if (xp_result->nodesetval->is_empty()) {
			message ("empty"); 
			delete xmldoc;
			availability = false;
			return false;
		}
		
		var text_result_node = xp_result->nodesetval->item (0);
		if (text_result_node == null) {
			message ("no item");
			delete xmldoc;
			availability = false;
			return false;
		}
		text = text_result_node->get_content();
		message (text);
		delete xmldoc;
				
		return true;
	}
		
	
	public bool? available() {
		return availability;
	}
	
	
	public void* fetch() {
		if (available() == null) fetch_hid();
		if (available() == false || hid == "") return null;
		
		bool retval = fetch_text ();
		sign_lyrics_fetched (text);
		return null;
	}
	
	
	public string get_text() {
		return text;
	}
	
	
	public string get_identifier() {
		return my_identifier;
	}
	
	
}
