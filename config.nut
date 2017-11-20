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
	slot_artwork_1 = {
		x = per(4.8, flw),
		y = per(8.5, flh),
		width = per(19, flw),
		height = per(32, flh),
	},
	slot_artwork_2 = {
		x = per(28.6, flw),
		y = per(8.5, flh),
		width = per(19, flw),
		height = per(32, flh),
	},
	slot_artwork_3 = {
		x = per(53.4, flw),
		y = per(8.5, flh),
		width = per(19, flw),
		height = per(32, flh),
	},
	slot_artwork_4 = {
		x = per(76.2, flw),
		y = per(8.5, flh),
		width = per(19, flw),
		height = per(32, flh),
	},
	slot_artwork_radius = per(1.5, flw),
	slot_favorite_1 = {
		x = per(5.8, flw),
		y = per(9.5, flh),
		width = per(4, flw),
		height = per(5, flh),
	},
	slot_favorite_2 = {
		x = per(29.6, flw),
		y = per(9.5, flh),
		width = per(4, flw),
		height = per(5, flh),
	},
	slot_favorite_3 = {
		x = per(54.4, flw),
		y = per(9.5, flh),
		width = per(4, flw),
		height = per(5, flh),
	},
	slot_favorite_4 = {
		x = per(77.2, flw),
		y = per(9.5, flh),
		width = per(4, flw),
		height = per(5, flh),
	},
	slot_entry_1 = {
		x = per(4.8, flw),
		y = per(43, flh),
		width = per(19, flw),
		height = per(4, flh),
		align = Align.Centre,
	},
	slot_entry_2 = {
		x = per(28.6, flw),
		y = per(43, flh),
		width = per(19, flw),
		height = per(4, flh),
		align = Align.Centre,
	},
	slot_entry_3 = {
		x = per(53.4, flw),
		y = per(43, flh),
		width = per(19, flw),
		height = per(4, flh),
		align = Align.Centre,
	},
	slot_entry_4 = {
		x = per(76.2, flw),
		y = per(43, flh),
		width = per(19, flw),
		height = per(4, flh),
		align = Align.Centre,
	},
}
