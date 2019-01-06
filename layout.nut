// --------------------
// Load Modules
// --------------------

fe.load_module("helpers");
fe.load_module("fade");
fe.load_module("shuffle");
fe.load_module("preserve-art");
fe.load_module("shader");

// --------------------
// Config
// --------------------

fe.do_nut("config.nut");

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
	marquee.alpha = per(userConfig["marqueeOpacity"].tointeger(), 255);

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
	artwork.push(PreserveArt("snap", config.artwork[0].x, config.artwork[0].y, config.artwork[0].width, config.artwork[0].height, container));
	artwork.push(PreserveArt("snap", config.artwork[1].x, config.artwork[1].y, config.artwork[1].width, config.artwork[1].height, container));
	artwork.push(PreserveArt("snap", config.artwork[2].x, config.artwork[2].y, config.artwork[2].width, config.artwork[2].height, container));
	artwork.push(PreserveArt("snap", config.artwork[3].x, config.artwork[3].y, config.artwork[3].width, config.artwork[3].height, container));

	for (local i=0; i<artwork.len(); i++) {
		artwork[i].set_fit_or_fill("fill");
		artwork[i].set_anchor(::Anchor.Center);
		artwork[i].art.video_flags = Vid.ImagesOnly;
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
	logos.push(PreserveArt("wheel", config.artwork[0].x, config.artwork[0].y, config.artwork[0].width, config.artwork[0].height, container));
	logos.push(PreserveArt("wheel", config.artwork[1].x, config.artwork[1].y, config.artwork[1].width, config.artwork[1].height, container));
	logos.push(PreserveArt("wheel", config.artwork[2].x, config.artwork[2].y, config.artwork[2].width, config.artwork[2].height, container));
	logos.push(PreserveArt("wheel", config.artwork[3].x, config.artwork[3].y, config.artwork[3].width, config.artwork[3].height, container));

	for (local i=0; i<logos.len(); i++) {
		logos[i].set_fit_or_fill("fit");
		logos[i].set_anchor(::Anchor.Top);
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
	favorites.push(PreserveImage("star.png", config.artwork[0].x, config.artwork[0].y + (config.artwork[0].height*0.75), config.artwork[0].width, config.artwork[0].height/4, container));
	favorites.push(PreserveImage("star.png", config.artwork[1].x, config.artwork[1].y + (config.artwork[0].height*0.75), config.artwork[1].width, config.artwork[1].height/4, container));
	favorites.push(PreserveImage("star.png", config.artwork[2].x, config.artwork[2].y + (config.artwork[0].height*0.75), config.artwork[2].width, config.artwork[2].height/4, container));
	favorites.push(PreserveImage("star.png", config.artwork[3].x, config.artwork[3].y + (config.artwork[0].height*0.75), config.artwork[3].width, config.artwork[3].height/4, container));

	for (local i=0; i<favorites.len(); i++) {
		setFavoritesColor(favorites[i].art);
		favorites[i].set_fit_or_fill("fit");
		favorites[i].set_anchor(::Anchor.Left);
	}

local shuffleFavorites = ShuffleFavorites(favorites, "preserveImage", false);

// ---------- Game Title

local gameTitleT = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitleT, config.gameTitle);
	gameTitleT.set_rgb(0, 0, 0);
	gameTitleT.x = config.gameTitle.x - (overscan*0.25);

local gameTitleL = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitleL, config.gameTitle);
	gameTitleL.set_rgb(0, 0, 0);
	gameTitleL.y = config.gameTitle.y - (overscan*0.25);

local gameTitleB = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitleB, config.gameTitle);
	gameTitleB.set_rgb(0, 0, 0);
	gameTitleB.x = config.gameTitle.x + (overscan*0.25);

local gameTitleR = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitleR, config.gameTitle);
	gameTitleR.set_rgb(0, 0, 0);
	gameTitleR.y = config.gameTitle.y + (overscan*0.25);

local gameTitleTL = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitleTL, config.gameTitle);
	gameTitleTL.set_rgb(0, 0, 0);
	gameTitleTL.set_pos(config.gameTitle.x-(overscan*0.25), config.gameTitle.y-(overscan*0.25));

local gameTitleBL = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitleBL, config.gameTitle);
	gameTitleBL.set_rgb(0, 0, 0);
	gameTitleBL.set_pos(config.gameTitle.x+(overscan*0.25), config.gameTitle.y-(overscan*0.25));

local gameTitleBR = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitleBR, config.gameTitle);
	gameTitleBR.set_rgb(0, 0, 0);
	gameTitleBR.set_pos(config.gameTitle.x+(overscan*0.25), config.gameTitle.y+(overscan*0.25));

local gameTitleTR = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitleTR, config.gameTitle);
	gameTitleTR.set_rgb(0, 0, 0);
	gameTitleTR.set_pos(config.gameTitle.x-(overscan*0.25), config.gameTitle.y+(overscan*0.25));

local gameTitle = container.add_text("[!magicGameTitle]", -1, -1, 1, 1);
	setProps(gameTitle, config.gameTitle);

// ---------- Game Info

local gameInfoBR = container.add_text("[Year] [Manufacturer]", -1, -1, 1, 1);
	setProps(gameInfoBR, config.gameInfo);
	gameInfoBR.set_rgb(0, 0, 0);
	gameInfoBR.set_pos(config.gameInfo.x+(overscan*0.25), config.gameInfo.y+(overscan*0.25));

local gameInfo = container.add_text("[Year] [Manufacturer]", -1, -1, 1, 1);
	setProps(gameInfo, config.gameInfo);

// ---------- Display Name

local displayNameBR = container.add_text("[DisplayName]", -1, -1, 1, 1);
	setProps(displayNameBR, config.displayName);
	displayNameBR.set_rgb(0, 0, 0);
	displayNameBR.set_pos(config.displayName.x+(overscan*0.25), config.displayName.y+(overscan*0.25));

local displayName = container.add_text("[DisplayName]", -1, -1, 1, 1);
	setProps(displayName, config.displayName);

// ---------- Filter Name

local filterNameBR = container.add_text("[FilterName]", -1, -1, 1, 1);
	setProps(filterNameBR, config.filterName);
	filterNameBR.set_rgb(0, 0, 0);
	filterNameBR.set_pos(config.filterName.x+(overscan*0.25), config.filterName.y+(overscan*0.25));

local filterName = container.add_text("[FilterName]", -1, -1, 1, 1);
	setProps(filterName, config.filterName);

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
	fe.game_info(Info.Favourite) == "1" ? setFavoritesColor(gameTitle) : gameTitle.set_rgb(255, 255, 255);
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
