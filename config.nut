local flw = fe.layout.width;
local flh = fe.layout.height;

fe.layout.font = "VAG Rounded Bold";

::config <- {
	snap = {
		x = 0,
		y = 0,
		width = flw,
		height = flh,
	},
	instructions = {
		x = per(70.2, flw),
		y = per(83.2, flh),
		width = per(25, flw),
		height = per(12, flh),
	},
	marquee = {
		x = 0,
		y = 0,
		width = flw,
		height = per(49, flh),
		red = 0, green = 0, blue = 0,
	},
	display = {
		x = per(4.8, flw),
		y = per(2, flh),
		width = per(19, flw),
		height = per(4, flh),
		align = Align.Left,
	},
	title = {
		x = per(28.6, flw),
		y = per(2, flh),
		width = per(42.8, flw),
		height = per(4, flh),
		align = Align.Centre,
	},
	filter = {
		x = per(76.2, flw),
		y = per(2, flh),
		width = per(19, flw),
		height = per(4, flh),
		align = Align.Right,
	},
	artwork = [
		{
			x = per(4.8, flw),
			y = per(8.5, flh),
			width = per(19, flw),
			height = per(32, flh),
		},
		{
			x = per(28.6, flw),
			y = per(8.5, flh),
			width = per(19, flw),
			height = per(32, flh),
		},
		{
			x = per(53.4, flw),
			y = per(8.5, flh),
			width = per(19, flw),
			height = per(32, flh),
		},
		{
			x = per(76.2, flw),
			y = per(8.5, flh),
			width = per(19, flw),
			height = per(32, flh),
		},
	],
	artwork_radius = per(1.5, flw),
	favorite = [
		{
			x = per(5.8, flw),
			y = per(9.5, flh),
			width = per(4, flw),
			height = per(5, flh),
		},
		{
			x = per(29.6, flw),
			y = per(9.5, flh),
			width = per(4, flw),
			height = per(5, flh),
		},
		{
			x = per(54.4, flw),
			y = per(9.5, flh),
			width = per(4, flw),
			height = per(5, flh),
		},
		{
			x = per(77.2, flw),
			y = per(9.5, flh),
			width = per(4, flw),
			height = per(5, flh),
		},
	],
	entry = [
		{
			x = per(4.8, flw),
			y = per(43, flh),
			width = per(19, flw),
			height = per(4, flh),
			align = Align.Centre,
		},
		{
			x = per(28.6, flw),
			y = per(43, flh),
			width = per(19, flw),
			height = per(4, flh),
			align = Align.Centre,
		},
		{
			x = per(53.4, flw),
			y = per(43, flh),
			width = per(19, flw),
			height = per(4, flh),
			align = Align.Centre,
		},
		{
			x = per(76.2, flw),
			y = per(43, flh),
			width = per(19, flw),
			height = per(4, flh),
			align = Align.Centre,
		},
	],
}
