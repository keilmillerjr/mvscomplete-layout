// --------------------
// Load Modules
// --------------------

fe.load_module("helpers");
fe.load_module("fade");
fe.load_module("shuffle");
fe.load_module("preserve-art");
fe.load_module("shader");

// --------------------
// Layout User Options
// --------------------

local userConfig = {
	order = 0,
	prefix = "---------- ",
	postfix = " ----------",
}

class UserConfig {
	</ label=userConfig.prefix + "GENERAL" + userConfig.postfix,
		help="mvscomplete Layout",
		order=userConfig.order++ />
	general="";

		</ label="Force 4:3 aspect",
			help="Force video to play in 4:3 aspect ratio.",
			options="Yes, No",
			order=userConfig.order++ />
		force="No";

		</ label="Format Game Title",
			help="Remove parenthesis, slashes, brackets and following text from game title.",
			options="Yes, No",
			order=userConfig.order++ />
		gameTitle="Yes";

		</ label="Favorites Color",
			help="Favorites logo and title color, defined by separated values for Red, Green, Blue. Default is neo-geo red 231, 45, 53.",
			order=userConfig.order++ />
		favoritesColor="235, 45, 53";

		</ label="Mini Marquee - Missing Art",
			help="When a snap image is not provided, one of these default mini marquees will be used.",
			options="Cabinet, Logo",
			order=userConfig.order++ />
		miniArt="Cabinet";

		</ label="Slot Artwork Shade",
			help="Percentage of shade for non selected slot artwork.",
			order=userConfig.order++ />
		artworkShade="40";

		</ label="Marquee Opacity",
			help="Percentage of opacity for marquee background.",
			order=userConfig.order++ />
		marqueeOpacity="75";

	</ label=userConfig.prefix + "AUDIO" + userConfig.postfix,
		order=userConfig.order++ />
	audio="";

		</ label="Navigation Audio",
			help="Audio effects when navigating the layout.",
			options="On, Off",
			order=userConfig.order++ />
		navigationAudio="On";

		</ label="Video Snap Audio",
			help="Audio when video snap is playing.",
			options="On, Off",
			order=userConfig.order++ />
		videoAudio="On";

	</ label=userConfig.prefix + "SHADERS" + userConfig.postfix,
		order=userConfig.order++ />
	shaders="";

		</ label="CRT Shader",
			help="CRT Shader applied.",
			options="Disabled, Crt Cgwg, Crt Lottes",
			order=userConfig.order++ />
		crtShader="Disabled";

		</ label="Enable Bloom Shader",
			help="Bloom applied with CRT shaders.",
			options="Yes, No",
			order=userConfig.order++ />
		bloom="No";
}
local userConfig = fe.get_config();

// --------------------
// Config
// --------------------

fe.layout.font = "Roboto-Bold";

local flw = fe.layout.width;
local flh = fe.layout.height;
local overscan = per(2, flh);

local config = {};

// ---------- Main Objects

config.containerParent <- {
	x = toBool(userConfig["force"]) ? (flw - matchAspect(4, 3, "height", flh)) / 2 : 0,
	y = 0,
	width = toBool(userConfig["force"]) ? matchAspect(4, 3, "height", flh) : flw,
	height = flh,
};

config.container <- {
	x = 0,
	y = 0,
	width = toBool(userConfig["force"]) ? matchAspect(4, 3, "height", flh) : flw,
	height = flh,
};

config.video <- {
	x = 0,
	y = 0,
	width = config.container.width,
	height = config.container.height,
};

// ---------- Marquee

config.marquee <- {
	x = 0,
	y = 0,
	width = config.container.width,
	height = per(40, config.container.height),
	alpha = per(userConfig["marqueeOpacity"].tointeger(), 255),
	rgb = [0, 0, 0],
};

config.artwork <- [];

config.artwork.push({
	x = overscan + (per(25, config.marquee.width-(overscan*2)) / 2) - (matchAspect(4, 5, "height", config.marquee.height - (overscan * 2)) / 2)
	y = overscan,
	width = matchAspect(4, 5, "height", config.marquee.height - (overscan * 2)),
	height = config.marquee.height - (overscan * 2),
});

config.artwork.push({
	x = config.artwork[0].x + per(25, config.marquee.width-(overscan*2)),
	y = config.artwork[0].y,
	width = config.artwork[0].width,
	height = config.artwork[0].height,
});

config.artwork.push({
	x = config.artwork[1].x + per(25, config.marquee.width-(overscan*2)),
	y = config.artwork[0].y,
	width = config.artwork[0].width,
	height = config.artwork[0].height,
});

config.artwork.push({
	x = config.artwork[2].x + per(25, config.marquee.width-(overscan*2)),
	y = config.artwork[0].y,
	width = config.artwork[0].width,
	height = config.artwork[0].height,
});

// ---------- Text Objects

config.gameTitle <- {
	x = overscan,
	y = config.container.height - per(12, config.container.height - (overscan*2)) - (overscan*1.5),
	width = per(62.5, config.container.width - (overscan*3)),
	height = per(6, config.container.height - (overscan*2)),
	align = Align.Left,
	rgb = [255, 255, 255],
}

config.gameTitleOutline <- {
	rgb = [0, 0, 0],
}

config.gameInfo <- {
	x = overscan,
	y = config.container.height - per(6, config.container.height - (overscan*2)) - overscan,
	width = per(62.5, config.container.width - (overscan*3)),
	height = per(6, config.container.height - (overscan*2)),
	align = Align.Left,
	rgb = [255, 255, 255],
}

config.gameInfoShadow <- {
	rgb = [0, 0, 0],
}

config.displayName <- {
	x = overscan + per(62.5, config.container.width - (overscan*3)),
	y = config.container.height - per(12, config.container.height - (overscan*2)) - (overscan*1.5),
	width = per(37.5, config.container.width - (overscan*3)),
	height = per(6, config.container.height - (overscan*2)),
	align = Align.Right,
	rgb = [255, 255, 255],
}

config.displayNameShadow <- {
	rgb = [0, 0, 0],
}

config.filterName <- {
	x = overscan + per(62.5, config.container.width - (overscan*3)),
	y = config.container.height - per(6, config.container.height - (overscan*2)) - overscan,
	width = per(37.5, config.container.width - (overscan*3)),
	height = per(6, config.container.height - (overscan*2)),
	align = Align.Right,
	rgb = [255, 255, 255],
}

config.filterNameShadow <- {
	rgb = [0, 0, 0],
}

// --------------------
// Functions
// --------------------

function magicGameTitle() {
	if (toBool(userConfig.gameTitle) && (fe.game_info(Info.Title) != "")) {
		local s = split(fe.game_info(Info.Title), "(/[");
		return rstrip(s[0]);
	}
	else return fe.game_info(Info.Title);
}

function setFavoritesColor(obj) {
	local s = split(userConfig["favoritesColor"], " ,./");
	try {
		obj.set_rgb(s[0].tointeger(), s[1].tointeger(), s[2].tointeger());
	}
	catch(e) {
		printL("mvscomplete: invalid favorites color, using default");
		obj.set_rgb(235, 45, 54);
	}
}

function textOutline(obj, offset) {
	try {
		obj[0].x = obj[8].y - offset; // Top
		obj[1].y = obj[8].x - offset; // Left
		obj[2].x = obj[8].y + offset; // Bottom
		obj[3].y = obj[8].x + offset; // Right
		obj[4].set_pos(obj[8].x - offset, obj[8].y - offset); // Top Left
		obj[5].set_pos(obj[8].x - offset, obj[8].y + offset); // Bottom Left
		obj[6].set_pos(obj[8].x + offset, obj[8].y + offset); // Bottom Right
		obj[7].set_pos(obj[8].x + offset, obj[8].y - offset); // Top Right
	}
	catch(e) {
		printL("mvscomplete: invalid objects or offset passed to textOutline function");
	}
}

function textShadow(obj, offset, direction) {
	try {
		switch (direction) {
			case "top":
			case "t":
				obj[0].y = obj[1].y - offset;
				break;
			case "left":
			case "l":
				obj[0].x = obj[1].x - offset;
				break;
			case "bottom":
			case "b":
				obj[0].y = obj[1].y + offset;
				break;
			case "right":
			case "r":
				obj[0].x = obj[1].x + offset;
				break;
			case "top-left":
			case "tl":
				obj[0].set_pos(obj[1].x - offset, obj[1].y - offset);
				break;
			case "bottom-left":
			case "bl":
				obj[0].set_pos(obj[1].x - offset, obj[1].y + offset);
				break;
			case "bottom-right":
			case "br":
				obj[0].set_pos(obj[1].x + offset, obj[1].y + offset);
				break;
			case "top-right":
			case "tr":
				obj[0].set_pos(obj[1].x + offset, obj[1].y - offset);
				break;
			default:
				printL("mvscomplete: invalid direction passed to textShadow function");
				break;
		}
	}
	catch(e) {
		printL("mvscomplete: invalid objects or offset passed to textShadow function");
	}
}

// --------------------
// Layout
// --------------------

// ---------- Container

local containerParent = fe.add_surface(config.containerParent.width, config.containerParent.height);
	setProps(containerParent, config.containerParent);

local container = containerParent.add_surface(config.container.width, config.container.height);
	setProps(container, config.container);

// ---------- Video

class FadeVideo extends FadeArt {
	constructor(label, x, y, width, height, audio=true, target=::fe) {
		base.constructor(label, x, y, width, height, target);

		if (audio == false) {
			_back.video_flags = Vid.NoAudio;
			_front.video_flags = Vid.NoAudio;
		}
	}
}

local video = FadeVideo("snap", -1, -1, 1, 1, toBool(userConfig["videoAudio"]), container);
	setProps(video, config.video);

// ---------- Marquee

local marquee = container.add_image(pixelPath, -1, -1, 1, 1);
	setProps(marquee, config.marquee);

// ---------- Artwork

class ShuffleArtwork extends Shuffle {
	function update() {
		base.update();

		for (local i=0; i<slots.len(); i++) {
			if (slots[i].art.file_name.len() == 0) slots[i].art.file_name = "mini" + userConfig.miniArt + ".png";
		}
	}

	function select(slot) {
		shadeObject(slot, 100);
	}

	function deselect(slot) {
		shadeObject(slot, userConfig.artworkShade.tointeger());
	}
}

local artwork = [];
	for (local i=0; i<4; i++) {
		artwork.push(PreserveArt("snap", config.artwork[i].x, config.artwork[i].y, config.artwork[i].width, config.artwork[i].height, container));
		artwork[i].set_fit_or_fill("fill");
		artwork[i].set_anchor(::Anchor.Center);
		artwork[i].art.video_flags = Vid.ImagesOnly;
		artwork[i].mipmap = true;
	}

local shuffleArtwork = ShuffleArtwork(artwork, "preserveArt", false);

// ---------- Logos

class ShuffleLogos extends Shuffle {
	function select(slot) {
		shadeObject(slot, 100);
	}

	function deselect(slot) {
		shadeObject(slot, userConfig.artworkShade.tointeger());
	}
}

local logos = [];
	for (local i=0; i<4; i++) {
		logos.push(PreserveArt("wheel", config.artwork[i].x, config.artwork[i].y, config.artwork[i].width, config.artwork[i].height, container));
		logos[i].set_fit_or_fill("fit");
		logos[i].set_anchor(::Anchor.Top);
		artwork[i].mipmap = true;
	}

local shuffleLogos = ShuffleLogos(logos, "preserveArt", false);

// ---------- Favorites

class ShuffleFavorites extends Shuffle {
	function update() {
		base.update();

		for (local i=0; i<slots.len(); i++) {
			fe.game_info(Info.Favourite, slots[i].art.index_offset) == "1" ? slots[i].visible = true : slots[i].visible = false;
		}
	}

	function select(slot) {
		shadeObject(slot, 100);
	}

	function deselect(slot) {
		shadeObject(slot, userConfig.artworkShade.tointeger());
	}
}

local favorites = [];
	for (local i=0; i<4; i++) {
		favorites.push(PreserveImage("star.png", config.artwork[i].x, config.artwork[i].y + (config.artwork[i].height*0.75), config.artwork[i].width, config.artwork[i].height/4, container));
		favorites[i].set_fit_or_fill("fit");
		favorites[i].set_anchor(::Anchor.Left);
		setFavoritesColor(favorites[i].art);
	}

local shuffleFavorites = ShuffleFavorites(favorites, "preserveImage", false);

// ---------- Game Title

local gameTitle = [];
	for (local i=0; i<9; i++) {
		gameTitle.push(container.add_text("[!magicGameTitle]", -1, -1, 1, 1));
		setProps(gameTitle[i], config.gameTitle);

		if (i<8) setProps(gameTitle[i], config.gameTitleOutline);
	}
	textOutline(gameTitle, overscan*0.25);

// ---------- Game Info

local gameInfo = [];
	for (local i=0; i<2; i++) {
		gameInfo.push(container.add_text("[Year] [Manufacturer]", -1, -1, 1, 1));
		setProps(gameInfo[i], config.gameInfo);

		if (i<1) setProps(gameInfo[i], config.gameInfoShadow);
	}
	textShadow(gameInfo, overscan*0.25, "br");

// ---------- Display Name

local displayName = [];
	for (local i=0; i<2; i++) {
		displayName.push(container.add_text("[DisplayName]", -1, -1, 1, 1));
		setProps(displayName[i], config.displayName);

		if (i<1) setProps(displayName[i], config.displayNameShadow);
	}
	textShadow(displayName, overscan*0.25, "bl");

// ---------- Filter Name

local filterName = [];
	for (local i=0; i<2; i++) {
		filterName.push(container.add_text("[FilterName]", -1, -1, 1, 1));
		setProps(filterName[i], config.filterName);

		if (i<1) setProps(filterName[i], config.filterNameShadow);
	}
	textShadow(filterName, overscan*0.25, "bl");

// --------------------
// Sounds
// --------------------

local click = fe.add_sound("click.wav");
	click.loop = false;
	click.playing = false;

local select = fe.add_sound("select.mp3"); // duration via terminal $ afinfo select.mp3 : 2.063650 sec
	select.loop = false;
	select.playing = false;

if (toBool(userConfig["navigationAudio"])) {
	fe.add_transition_callback("navigationAudio");
	function navigationAudio(ttype, var, ttime) {
		switch(ttype) {
			case Transition.ToNewSelection:
			case Transition.ToNewList:
			case Transition.ChangedTag:
				click.playing = true;
				break;
			case Transition.ToGame:
				if (ttime == 0) select.playing = true;
				if (ttime < 2063) return true;
				break;
		}
		return false;
	}
}

// --------------------
// Shaders
// --------------------

local shaderCrtLottes = CrtLottes();
local shaderCrtCgwg = CrtCgwg();
local shaderBloom = Bloom();

switch (userConfig["crtShader"]){
	case "Crt Lottes":
		if (toBool(userConfig["bloom"])) containerParent.shader = shaderBloom.shader;
		container.shader = shaderCrtLottes.shader;
		break;
	case "Crt Cgwg":
		if (toBool(userConfig["bloom"])) containerParent.shader = shaderBloom.shader;
		container.shader = shaderCrtCgwg.shader;
		break;
	default:
		containerParent.shader = fe.add_shader(Shader.Empty);
		container.shader = fe.add_shader(Shader.Empty);
		break;
}

// --------------------
// Transitions
// --------------------

fe.add_transition_callback("favorites");
function favorites(ttype, var, ttime) {
	fe.game_info(Info.Favourite) == "1" ? setFavoritesColor(gameTitle[8]) : gameTitle[8].set_rgb(config.gameInfo.rgb[0], config.gameInfo.rgb[1], config.gameInfo.rgb[2]);
	return false;
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
			shuffleArtwork.selected = fe.nv.mvscomplete.selectedSlot;
			shuffleArtwork.update();
			shuffleLogos.selected = fe.nv.mvscomplete.selectedSlot;
			shuffleLogos.update();
			shuffleFavorites.selected = fe.nv.mvscomplete.selectedSlot;
			shuffleFavorites.update();
			break;
		case Transition.EndLayout:
			fe.nv.mvscomplete.selectedSlot = shuffleArtwork.selected;
			break;
	}
	return false;
}
