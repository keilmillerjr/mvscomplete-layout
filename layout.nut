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

}
local config = fe.get_config();

// --------------------
// Layout Constants
// --------------------
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font = "VAG Rounded Bold";

// --------------------
// Colors
// --------------------
local colors = {
	black = { r = 0, g = 0, b = 0 },
	white = { r = 255, g = 255, b = 255 },
	grey = { r = 120, g = 120, b = 120 },
	yellow = { r = 255, g = 254, b = 0 },
	red = { r = 246, g = 36, b = 10 },
}

// --------------------
// Settings
// --------------------
local settings = {
	snap = {
		x = 0,
		y = 0,
		width = flw,
		height = flh,
	},
	instructions = {
		x = percentage(65.2, flw),
		y = percentage(85, flh),
		width = percentage(30, flw),
		height = percentage(13, flh),
	},
	marquee = {
		x = 0,
		y = 0,
		width = flw,
		height = percentage(49, flh),
		red = colors.black.r, green = colors.black.g, blue = colors.black.b,
		alpha = percentage(config["marqueeOpacity"].tointeger(), 255),
	},
	title = {
		x = percentage(28.6, flw),
		y = percentage(2, flh),
		width = percentage(42.8, flw),
		height = percentage(4, flh),
		align = Align.Centre,
	},
	filter = {
		x = percentage(76.2, flw),
		y = percentage(2, flh),
		width = percentage(19, flw),
		height = percentage(4, flh),
		align = Align.Right,
	},
	slot_artwork_1 = {
		x = percentage(4.8, flw),
		y = percentage(8.5, flh),
		width = percentage(19, flw),
		height = percentage(32, flh),
	},
	slot_artwork_2 = {
		x = percentage(28.6, flw),
		y = percentage(8.5, flh),
		width = percentage(19, flw),
		height = percentage(32, flh),
	},
	slot_artwork_3 = {
		x = percentage(53.4, flw),
		y = percentage(8.5, flh),
		width = percentage(19, flw),
		height = percentage(32, flh),
	},
	slot_artwork_4 = {
		x = percentage(76.2, flw),
		y = percentage(8.5, flh),
		width = percentage(19, flw),
		height = percentage(32, flh),
	},
	slot_artwork_radius = percentage(1.5, flw),
	slot_favorite_1 = {
		x = percentage(5.8, flw),
		y = percentage(9.5, flh),
		width = percentage(4, flw),
		height = percentage(5, flh),
	},
	slot_favorite_2 = {
		x = percentage(29.6, flw),
		y = percentage(9.5, flh),
		width = percentage(4, flw),
		height = percentage(5, flh),
	},
	slot_favorite_3 = {
		x = percentage(54.4, flw),
		y = percentage(9.5, flh),
		width = percentage(4, flw),
		height = percentage(5, flh),
	},
	slot_favorite_4 = {
		x = percentage(77.2, flw),
		y = percentage(9.5, flh),
		width = percentage(4, flw),
		height = percentage(5, flh),
	},
	slot_entry_1 = {
		x = percentage(4.8, flw),
		y = percentage(43, flh),
		width = percentage(19, flw),
		height = percentage(4, flh),
		align = Align.Centre,
	},
	slot_entry_2 = {
		x = percentage(28.6, flw),
		y = percentage(43, flh),
		width = percentage(19, flw),
		height = percentage(4, flh),
		align = Align.Centre,
	},
	slot_entry_3 = {
		x = percentage(53.4, flw),
		y = percentage(43, flh),
		width = percentage(19, flw),
		height = percentage(4, flh),
		align = Align.Centre,
	},
	slot_entry_4 = {
		x = percentage(76.2, flw),
		y = percentage(43, flh),
		width = percentage(19, flw),
		height = percentage(4, flh),
		align = Align.Centre,
	},
}

// --------------------
// Magic Functions
// --------------------
function titleString(index_offset = 0) {
	local s = fe.game_info(Info.Title, index_offset).toupper();
	if (toBool(config.hideBrackets)) s = split(s, "(/[");
	return rstrip(s[0]);
}

function filterString() {
	return fe.filters[fe.list.filter_index].name.toupper();
}

//function favoriteString(index_offset) {
//	return fe.game_info(Info.Favourite, index_offset) == "1" ? "" : "";
//}

function favoriteString(index_offset) {
	return fe.game_info(Info.Favourite, index_offset) == "1" ? "heart-red.png" : "";
}

// --------------------
// Layout
// --------------------
local snap = FadeArt("snap", -1, -1, 1, 1);
	setProperties(snap, settings.snap);

local instructions = fe.add_image("instructions.png", -1, -1, 1, 1);
	setProperties(instructions, settings.instructions);
	if (!toBool(config.enableInstructions)) { instructions.visible = false; }

local marquee = fe.add_image("white.png", -1, -1, 1, 1);
	setProperties(marquee, settings.marquee);

local title = fe.add_text("[!titleString]", -1, -1, 1, 1);
	setProperties(title, settings.title);

local filter = fe.add_text("[!filterString]", -1, -1, 1, 1);
	setProperties(filter, settings.filter);

local mvs = MVS(config.slotArtworkType, config.slotArtworkShade, 4, true);
	setProperties(mvs.slot_artwork[0], settings.slot_artwork_1);
	setProperties(mvs.slot_artwork[1], settings.slot_artwork_2);
	setProperties(mvs.slot_artwork[2], settings.slot_artwork_3);
	setProperties(mvs.slot_artwork[3], settings.slot_artwork_4);
	setProperties(mvs.slot_favorite[0], settings.slot_favorite_1);
	setProperties(mvs.slot_favorite[1], settings.slot_favorite_2);
	setProperties(mvs.slot_favorite[2], settings.slot_favorite_3);
	setProperties(mvs.slot_favorite[3], settings.slot_favorite_4);
	setProperties(mvs.slot_entry[0], settings.slot_entry_1);
	setProperties(mvs.slot_entry[1], settings.slot_entry_2);
	setProperties(mvs.slot_entry[2], settings.slot_entry_3);
	setProperties(mvs.slot_entry[3], settings.slot_entry_4);

// --------------------
// Transitions
// --------------------

// --------------------
// Enable Shaders
// --------------------
if (fe.load_module("shader")) {
	// Snap Shader
	if (toBool(config.enableSnapShader)) {
		snapShader <- CrtLottes(splitRes(config.shaderResolution, "width"), splitRes(config.shaderResolution, "height"));
		snap.shader = snapShader.shader;
	}
	
	// Slot Artwork Shader
	slotArtworkShader <- RoundCorners(settings.slot_artwork_radius, settings.slot_artwork_1.width, settings.slot_artwork_1.height);
		mvs.slot_artwork[0].shader = slotArtworkShader.shader;
		mvs.slot_artwork[1].shader = slotArtworkShader.shader;
		mvs.slot_artwork[2].shader = slotArtworkShader.shader;
		mvs.slot_artwork[3].shader = slotArtworkShader.shader;
}
