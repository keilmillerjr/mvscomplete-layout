// --------------------
// Load Modules
// --------------------
fe.load_module("helpers");
fe.load_module("shuffle");
fe.load_module("shader");

fe.load_module("fade");
fe.load_module("animate");

// --------------------
// Layout User Options
// --------------------
class UserConfig {
	</ label="Enable CRT Shader on Background",
		help="Snap and Artwork is simulated to look like it is being displayed on a crt.",
		options="Yes, No",
		order=1 />
	enableSnapShader="No";
	
	</ label="CRT Shader Resolution",
		help="Select CRT resolution.",
		options="640x480, 320x240",
		order=2 />
	shaderResolution="320x240";
	
	</ label="Hide Brackets in Game Title",
		help="Hide brackets in game title.",
		options="Yes, No",
		order=3 />
	hideBrackets="Yes";
	
	</ label="Marquee Opacity",
		help="Percentage of opacity for marquee background.",
		order=4 />
	marqueeOpacity="85";
	
	</ label="Slot Artwork Type",
		help="Type of slot artwork to display.",
		order=5 />
	artworkType="marquee";
	
	</ label="Slot Artwork Shade",
		help="Percentage of shade for non selected slot artwork.",
		order=6 />
	artworkShade="50";
	
	</ label="Favorite Image",
		help="Select which image to show for favorites.",
		options="Star, Heart",
		order=7 />
	favoriteImage="Star";
	
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
function displayString() {
	return fe.displays[fe.list.display_index].name.toupper();
}

function titleString(index_offset = 0) {
	local s = fe.game_info(Info.Title, index_offset).toupper();
	if (toBool(user_config.hideBrackets)) s = split(s, "(/[");
	return rstrip(s[0]);
}

function filterString() {
	return fe.filters[fe.list.filter_index].name.toupper();
}

// --------------------
// Layout
// --------------------
local snap = FadeArt("snap", -1, -1, 1, 1);
	setProps(snap, config.snap);
	
local marquee = fe.add_image("white.png", -1, -1, 1, 1);
	setProps(marquee, config.marquee);
	marquee.alpha = per(user_config["marqueeOpacity"].tointeger(), 255);

local container = fe.add_surface(config.container.width, config.container.height);
	setProps(container, config.container);

local display = container.add_text("[!displayString]", -1, -1, 1, 1);
	setProps(display, config.display);

local title = container.add_text("[!titleString]", -1, -1, 1, 1);
	setProps(title, config.title);

local filter = container.add_text("[!filterString]", -1, -1, 1, 1);
	setProps(filter, config.filter);

class ShuffleArtwork extends Shuffle {
	function select(slot) {
		shadeObject(slot, 100);
	}

	function deselect(slot) {
		shadeObject(slot, user_config.artworkShade.tointeger());
	}
}
local artwork = ShuffleArtwork(4, "artwork", user_config.artworkType, false, container);
	setProps(artwork.slots[0], config.artwork[0]);
	setProps(artwork.slots[1], config.artwork[1]);
	setProps(artwork.slots[2], config.artwork[2]);
	setProps(artwork.slots[3], config.artwork[3]);

class ShuffleFavorite extends Shuffle {
	config = null;
	
	constructor(pm="image", r=true, pt=::fe) {
		base.constructor(4, "image", pm, r, pt);
		
		config = {
			frame = 0,
			time = 1920,
			delay = 0,
			wait = false,
			loop = true,
			width = 50,
			height = 50,
			orientation = "horizontal",
		}
		for (local i=0; i<slots.len(); i++) {
			animation.add(SpriteAnimation(slots[i], config));
		}
		
		fe.add_transition_callback(this, "status");
	}
	
	function status(ttype, var, ttime) {
		for (local i=0; i<slots.len(); i++) {
			fe.game_info(Info.Favourite, slots[i].index_offset) == "1" ? slots[i].visible = true : slots[i].visible = false;
		}
	}
	
	function select(slot) {
		shadeObject(slot, 100);
	}

	function deselect(slot) {
		shadeObject(slot, user_config.artworkShade.tointeger());
	}
}
local favorite = ShuffleFavorite(user_config.favoriteImage.tolower() + ".png", false, container);
	setProps(favorite.slots[0], config.favorite[0]);
	setProps(favorite.slots[1], config.favorite[1]);
	setProps(favorite.slots[2], config.favorite[2]);
	setProps(favorite.slots[3], config.favorite[3]);

local entry = Shuffle(4, "text", "[ListEntry]", false, container);
	setProps(entry.slots[0], config.entry[0]);
	setProps(entry.slots[1], config.entry[1]);
	setProps(entry.slots[2], config.entry[2]);
	setProps(entry.slots[3], config.entry[3]);
	
// --------------------
// Enable Shaders
// --------------------
if (fe.load_module("shader")) {
	// Snap Shader
	if (toBool(user_config.enableSnapShader)) {
		snapShader <- CrtLottes(splitRes(user_config.shaderResolution, "width"), splitRes(user_config.shaderResolution, "height"));
		snap.shader = snapShader.shader;
	}
}

// Slot Artwork Shader
artworkShader <- RoundCorners(config.artwork_radius, config.artwork[0].width, config.artwork[0].height);
	artwork.slots[0].shader = artworkShader.shader;
	artwork.slots[1].shader = artworkShader.shader;
	artwork.slots[2].shader = artworkShader.shader;
	artwork.slots[3].shader = artworkShader.shader;

// --------------------
// Sounds
// --------------------

local click = fe.add_sound("click.wav");
	click.loop = false;
	click.playing = false;

local select = fe.add_sound("select.mp3"); // duration via terminal $ afinfo select.mp3 : 2.063650 sec
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

// --------------------
// Save/Load Selected Slots
// --------------------

if (!fe.nv.rawin("mvscomplete")) fe.nv <- { mvscomplete = {}, };
if (!fe.nv.mvscomplete.rawin("selectedSlot")) fe.nv.mvscomplete <- { selectedSlot = 0, };

fe.add_transition_callback("slotState");
function slotState(ttype, var, ttime) {
	switch(ttype) {
		case Transition.StartLayout:
			artwork.selected = fe.nv.mvscomplete.selectedSlot;
			artwork.update();
			favorite.selected = fe.nv.mvscomplete.selectedSlot;
			favorite.update();
			entry.selected = fe.nv.mvscomplete.selectedSlot;
			entry.update();
			break;
		case Transition.EndLayout:
			fe.nv.mvscomplete.selectedSlot = artwork.selected;
			break;
	}
	return false;
}
