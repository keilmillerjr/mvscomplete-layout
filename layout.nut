// --------------------
// Load Modules
// --------------------
if (fe.load_module("debug")) log <- Log();
fe.load_module("shader");
fe.load_module("helpers");
fe.load_module("fade");
fe.load_module("mvs");


// --------------------
// Layout User Options
// --------------------
class UserConfig {
	</ label="Hide Brackets in Game Title",
		help="Hide brackets in game title.",
		options="Yes, No",
		order=1 />
	hideBrackets="Yes";
	
	</ label="Marquee Opacity",
		help="Percentage of opacity for marquee background.",
		order=2 />
	marqueeOpacity="85";
	
	</ label="Slot Artwork Type",
		help="Type of slot artwork to display.",
		order=3 />
	slotArtworkType="marquee";
	
	</ label="Slot Artwork Shade",
		help="Percentage of shade for non selected slot artwork.",
		order=4 />
	slotArtworkShade="50";
	
	</ label="Enable Instructions",
		help="Enable instructions for the layout.",
		options="Yes, No",
		order=5 />
	enableInstructions="Yes";
	
	</ label="Enable CRT Shader on Background",
		help="Snap and Artwork is simulated to look like it is being displayed on a crt.",
		options="Yes, No",
		order=6 />
	enableSnapShader="No";
	
	</ label="CRT Shader Resolution",
		help="Select CRT resolution.",
		options="640x480, 320x240",
		order=7 />
	shaderResolution="320x240";
	
	</ label="Enable SoundFx",
		help="Enable SoundFx.",
		options="Yes, No",
		order=8 />
	enableSoundFx="Yes";
}
local user_config = fe.get_config();

// --------------------
// Config
// --------------------
fe.do_nut("config.nut");

// --------------------
// Magic Functions
// --------------------
function titleString(index_offset = 0) {
	local s = fe.game_info(Info.Title, index_offset).toupper();
	if (toBool(user_config.hideBrackets)) s = split(s, "(/[");
	return rstrip(s[0]);
}

function filterString() {
	return fe.filters[fe.list.filter_index].name.toupper();
}

//function favoriteString(index_offset) {
//	return fe.game_info(Info.Favourite, index_offset) == "1" ? "" : "";
//}

function favoriteString(index_offset) {
	return fe.game_info(Info.Favourite, index_offset) == "1" ? "heart" : "";
}

// --------------------
// Layout
// --------------------
local snap = FadeArt("snap", -1, -1, 1, 1);
	setProps(snap, config.snap);

local instructions = fe.add_image("instructions.png", -1, -1, 1, 1);
	setProps(instructions, config.instructions);
	if (!toBool(user_config.enableInstructions)) { instructions.visible = false; }

local marquee = fe.add_image("white.png", -1, -1, 1, 1);
	setProps(marquee, config.marquee);
	marquee.alpha = per(user_config["marqueeOpacity"].tointeger(), 255);

local title = fe.add_text("[!titleString]", -1, -1, 1, 1);
	setProps(title, config.title);

local filter = fe.add_text("[!filterString]", -1, -1, 1, 1);
	setProps(filter, config.filter);

local mvs = MVS(user_config.slotArtworkType, user_config.slotArtworkShade, 4, true);
	setProps(mvs.slot_artwork[0], config.slot_artwork_1);
	setProps(mvs.slot_artwork[1], config.slot_artwork_2);
	setProps(mvs.slot_artwork[2], config.slot_artwork_3);
	setProps(mvs.slot_artwork[3], config.slot_artwork_4);
	setProps(mvs.slot_favorite[0], config.slot_favorite_1);
	setProps(mvs.slot_favorite[1], config.slot_favorite_2);
	setProps(mvs.slot_favorite[2], config.slot_favorite_3);
	setProps(mvs.slot_favorite[3], config.slot_favorite_4);
	setProps(mvs.slot_entry[0], config.slot_entry_1);
	setProps(mvs.slot_entry[1], config.slot_entry_2);
	setProps(mvs.slot_entry[2], config.slot_entry_3);
	setProps(mvs.slot_entry[3], config.slot_entry_4);

// --------------------
// Enable Shaders
// --------------------
if (fe.load_module("shader")) {
	// Snap Shader
	if (toBool(user_config.enableSnapShader)) {
		snapShader <- CrtLottes(splitRes(user_config.shaderResolution, "width"), splitRes(user_config.shaderResolution, "height"));
		snap.shader = snapShader.shader;
	}
	
	// Slot Artwork Shader
	slotArtworkShader <- RoundCorners(config.slot_artwork_radius, config.slot_artwork_1.width, config.slot_artwork_1.height);
		mvs.slot_artwork[0].shader = slotArtworkShader.shader;
		mvs.slot_artwork[1].shader = slotArtworkShader.shader;
		mvs.slot_artwork[2].shader = slotArtworkShader.shader;
		mvs.slot_artwork[3].shader = slotArtworkShader.shader;
}

// --------------------
// Sounds
// --------------------

local click = fe.add_sound("click.mp3");
	click.loop = false;
	click.playing = false;

local select = fe.add_sound("select.mp3"); // duration via terminal $ afinfo select.mp3 : 1.619575 sec
	select.loop = false;
	select.playing = false;

if (toBool(user_config.enableSoundFx)) {
	fe.add_signal_handler("soundFxSignals")
	function soundFxSignals(signal_str) {
		switch(signal_str) {
			case "prev_game":
			case "next_game":
			case "prev_filter":
			case "next_filter":
			case "add_favourite":
			case "prev_letter":
			case "next_letter":
				click.playing = true;
				break;
			case "select":
				select.playing = true;
				break;
		}
		return false;
	}
	
	fe.add_transition_callback("soundFxTransitions");
	function soundFxTransitions(ttype, var, ttime) {
		switch(ttype) {
			case Transition.ToGame:
				if (ttime < 1620) {
					return true;
				}
				break;
		}
		return false;
	}
}
