::flw <- fe.layout.width;
::flh <- fe.layout.height;
::overscan <- per(2, flh);

fe.layout.font = "Roboto-Bold";

::config <- {
	containerParent = {
		x = (flw - matchAspect(4, 3, "height", flh)) / 2,
		y = 0,
		width = matchAspect(4, 3, "height", flh),
		height = flh,
	},
	container = {
		x = 0,
		y = 0,
		width = matchAspect(4, 3, "height", flh),
		height = flh,
	},
};

config.video <- {
	x = 0,
	y = 0,
	width = config.container.width,
	height = config.container.height,
};

config.marquee <- {
	x = 0,
	y = 0,
	width = config.container.width,
	height = per(40, config.container.height),
	rgb = [0, 0, 0],
	alpha = 75,
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

config.artworkRadius <- overscan / 2;

config.gameTitle <- {
	x = overscan,
	y = config.container.height - per(12, config.container.height - (overscan*2)) - (overscan*1.5),
	width = per(62.5, config.container.width - (overscan*3)),
	height = per(6, config.container.height - (overscan*2)),
	align = Align.Left,
}

config.gameInfo <- {
	x = overscan,
	y = config.container.height - per(6, config.container.height - (overscan*2)) - overscan,
	width = per(62.5, config.container.width - (overscan*3)),
	height = per(6, config.container.height - (overscan*2)),
	align = Align.Left,
}

config.displayName <- {
	x = overscan + per(62.5, config.container.width - (overscan*3)),
	y = config.container.height - per(12, config.container.height - (overscan*2)) - (overscan*1.5),
	width = per(37.5, config.container.width - (overscan*3)),
	height = per(6, config.container.height - (overscan*2)),
	align = Align.Right,
}

config.filterName <- {
	x = overscan + per(62.5, config.container.width - (overscan*3)),
	y = config.container.height - per(6, config.container.height - (overscan*2)) - overscan,
	width = per(37.5, config.container.width - (overscan*3)),
	height = per(6, config.container.height - (overscan*2)),
	align = Align.Right,
}
