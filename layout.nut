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
	</ label="Marquee Opacity",
		help="Percentage of opacity for marquee background.",
		order=1 />
	marqueeOpacity="85";
	
	</ label="Slot Artwork Type",
		help="Type of slot artwork to display.",
		order=2 />
	slotArtworkType="marquee";
	
	</ label="Slot Artwork Shade",
		help="Percentage of shade for non selected slot artwork.",
		order=3 />
	slotArtworkShade="50";
	
	</ label="Enable CRT Shader on Background",
		help="Snap and Artwork is simulated to look like it is being displayed on a crt.",
		options="Yes, No",
		order=4 />
	enableSnapShader="No";
	
	</ label="CRT Shader Resolution",
		help="Select CRT resolution.",
		options="640x480, 320x240",
		order=5 />
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
	gradient = {
		x = 0,
		y = percentage(88, flh),
		width = flw,
		height = percentage(12, flh),
	},
	favorite = {
		x = percentage(2, flw),
		y = percentage(92, flh),
		width = percentage(4, flw),
		height = percentage(4, flh),
		align = Align.Left,
		red = colors.yellow.r, green = colors.yellow.g, blue = colors.yellow.b,
		font = "FontAwesome",
	},
	title = {
		x = percentage(2, flw),
		y = percentage(92, flh),
		width = percentage(47, flw),
		height = percentage(4, flh),
		align = Align.Left,
	},
	titleFavorite = {
		x = percentage(6, flw),
		y = percentage(92, flh),
		width = percentage(43, flw),
		height = percentage(4, flh),
		align = Align.Left,
	},
	copyright = {
		x = percentage(51, flw),
		y = percentage(92, flh),
		width = percentage(47, flw),
		height = percentage(4, flh),
		align = Align.Right,
	},
	marquee = {
		x = 0,
		y = 0,
		width = flw,
		height = percentage(49, flh),
		red = colors.black.r, green = colors.black.g, blue = colors.black.b,
		alpha = percentage(config["marqueeOpacity"].tointeger(), 255),
	},
	displayName = {
		x = percentage(28, flw),
		y = percentage(2, flh),
		width = percentage(44, flw),
		height = percentage(4, flh),
		align = Align.Centre,
	},
	filter = {
		x = percentage(76, flw),
		y = percentage(2, flh),
		width = percentage(20, flw),
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
function displayName() {
	return fe.list.name.toupper();
}

function favoriteString() {
	return fe.game_info(Info.Favourite) == "1" ? "" : "";
}

function titleString() {
	return fe.game_info(Info.Title).toupper();
}

function copyrightString() {
	return fe.game_info(Info.Year).toupper() + " " + fe.game_info(Info.Manufacturer).toupper();
}

function filterString() {
	return fe.filters[fe.list.filter_index].name.toupper();
}

// --------------------
// Layout
// --------------------
local snap = FadeArt("snap", -1, -1, 1, 1);
	setProperties(snap, settings.snap);

local gradient = fe.add_image("gradient.png", -1, -1, 1, 1);
	setProperties(gradient, settings.gradient);

local favorite = fe.add_text("[!favoriteString]", -1, -1, 1, 1);
	setProperties(favorite, settings.favorite);

local title = fe.add_text("[!titleString]", -1, -1, 1, 1);
	setProperties(title, settings.title);

local copyright = fe.add_text("[!copyrightString]", -1, -1, 1, 1);
	setProperties(copyright, settings.copyright);

local marquee = fe.add_image("white.png", -1, -1, 1, 1);
	setProperties(marquee, settings.marquee);

local displayName = fe.add_text("[!displayName]", -1, -1, 1, 1);
	setProperties(displayName, settings.displayName);

local filter = fe.add_text("[!filterString]", -1, -1, 1, 1);
	setProperties(filter, settings.filter);

local mvs = MVS(config["slotArtworkType"], config["slotArtworkShade"]);
	setProperties(mvs.slot_artwork[0], settings.slot_artwork_1);
	setProperties(mvs.slot_artwork[1], settings.slot_artwork_2);
	setProperties(mvs.slot_artwork[2], settings.slot_artwork_3);
	setProperties(mvs.slot_artwork[3], settings.slot_artwork_4);
	setProperties(mvs.slot_entry[0], settings.slot_entry_1);
	setProperties(mvs.slot_entry[1], settings.slot_entry_2);
	setProperties(mvs.slot_entry[2], settings.slot_entry_3);
	setProperties(mvs.slot_entry[3], settings.slot_entry_4);

// --------------------
// Transitions
// --------------------
fe.add_transition_callback("favoriteTransition");
function favoriteTransition(ttype, var, transition_time) {
	if (fe.game_info(Info.Favourite) == "1") {
		setProperties(title, settings.titleFavorite);
	}
	else {
		setProperties(title, settings.title);
	}
}

// --------------------
// Enable Shaders
// --------------------
if (fe.load_module("shader")) {
	// Snap Shader
	if (toBool(config["enableSnapShader"])) {
		snapShader <- CrtLottes(splitRes(config["shaderResolution"], "width"), splitRes(config["shaderResolution"], "height"));
		snap.shader = snapShader.shader;
	}
	
	// Slot Artwork Shader
	slotArtworkShader <- RoundCorners(settings.slot_artwork_radius, settings.slot_artwork_1.width, settings.slot_artwork_1.height);
	mvs.slot_artwork[0].shader = slotArtworkShader.shader;
	mvs.slot_artwork[1].shader = slotArtworkShader.shader;
	mvs.slot_artwork[2].shader = slotArtworkShader.shader;
	mvs.slot_artwork[3].shader = slotArtworkShader.shader;
}
