local flw = fe.layout.width;
local flh = fe.layout.height;
local overscan = per(2, flh);

fe.layout.font = "VAG Rounded Bold";

::config <- {
	snap = {
		x = 0,
		y = 0,
		width = flw,
		height = flh,
	},
	marquee = {
		x = 0,
		y = 0,
		width = flw,
		height = per(50, flh),
		rgb = [0, 0, 0],
	},
	marqueeRed = {
		rgb = [226, 52, 16],
	},
	container = {
		x = ((flw - matchAspect(4, 3, "height", flh)) / 2) + overscan,
		y = overscan,
		width = matchAspect(4, 3, "height", flh) - (overscan * 2),
		height = per(50, flh) - (overscan * 2),
	},
	artwork_radius = overscan / 2,
}

config.display <- {
	x = 0,
	y = 0,
	width = per(25, config.container.width),
	height = per(10, config.container.height),
	align = Align.Left,
	nomargin = true,
}

config.title <- {
	x = per(25, config.container.width),
	y = 0,
	width = per(50, config.container.width),
	height = per(10, config.container.height),
	align = Align.Centre,
}

config.filter <- {
	x = per(75, config.container.width),
	y = 0,
	width = per(25, config.container.width),
	height = per(10, config.container.height),
	align = Align.Right,
	nomargin = true,
}

config.artwork <- [
	{
		x = (per(25, config.container.width) - matchAspect(4, 5, "height", per(80, config.container.height) - (overscan * 2))) / 2,
		y = per(10, config.container.height) + overscan,
		width = matchAspect(4, 5, "height", per(80, config.container.height) - (overscan * 2)),
		height = per(80, config.container.height) - (overscan * 2),
	},
	{
		x = per(25, config.container.width) + ((per(25, config.container.width) - matchAspect(4, 5, "height", per(80, config.container.height) - (overscan * 2))) / 2),
		y = per(10, config.container.height) + overscan,
		width = matchAspect(4, 5, "height", per(80, config.container.height) - (overscan * 2)),
		height = per(80, config.container.height) - (overscan * 2),
	},
	{
		x = per(50, config.container.width) + ((per(25, config.container.width) - matchAspect(4, 5, "height", per(80, config.container.height) - (overscan * 2))) / 2),
		y = per(10, config.container.height) + overscan,
		width = matchAspect(4, 5, "height", per(80, config.container.height) - (overscan * 2)),
		height = per(80, config.container.height) - (overscan * 2),
	},
	{
		x = per(75, config.container.width) + ((per(25, config.container.width) - matchAspect(4, 5, "height", per(80, config.container.height) - (overscan * 2))) / 2),
		y = per(10, config.container.height) + overscan,
		width = matchAspect(4, 5, "height", per(80, config.container.height) - (overscan * 2)),
		height = per(80, config.container.height) - (overscan * 2),
	},
]

config.favorite <- [
	{
		x = config.artwork[0].x,
		y = config.artwork[0].y,
		width = per(20, config.artwork[0].width),
		height = matchAspect(1, 1, "width", per(20, config.artwork[0].width)),
	},
	{
		x = config.artwork[1].x,
		y = config.artwork[1].y,
		width = per(20, config.artwork[0].width),
		height = matchAspect(1, 1, "width", per(20, config.artwork[1].width)),
	},
	{
		x = config.artwork[2].x,
		y = config.artwork[2].y,
		width = per(20, config.artwork[0].width),
		height = matchAspect(1, 1, "width", per(20, config.artwork[2].width)),
	},
	{
		x = config.artwork[3].x,
		y = config.artwork[3].y,
		width = per(20, config.artwork[0].width),
		height = matchAspect(1, 1, "width", per(20, config.artwork[3].width)),
	},
]

config.entry <- [
	{
		x = 0,
		y = per(90, config.container.height),
		width = per(25, config.container.width),
		height = per(10, config.container.height),
		align = Align.Centre,
	},
	{
		x = per(25, config.container.width),
		y = per(90, config.container.height),
		width = per(25, config.container.width),
		height = per(10, config.container.height),
		align = Align.Centre,
	},
	{
		x = per(50, config.container.width),
		y = per(90, config.container.height),
		width = per(25, config.container.width),
		height = per(10, config.container.height),
		align = Align.Centre,
	},
	{
		x = per(75, config.container.width),
		y = per(90, config.container.height),
		width = per(25, config.container.width),
		height = per(10, config.container.height),
		align = Align.Centre,
	},
]
