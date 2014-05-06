import QtQuick 2.0
import QtMultimedia 5.0

VaporRectangle
{
	id: videoContainer
	color: "transparent"
	property alias source: player.source

	function play()
	{
        //player.play();//needs to be destroyed on closing?
		console.log(AppSettings.getVideoDirectory());
		console.log(player.source);
	}

	MediaPlayer
	{
		id: player
		source: AppSettings.getVideoDirectory()+"/turtles1.webm"
		muted: true
		autoPlay: false
	}

	VideoOutput
	{
		id: videoOutput
		source: player
		anchors.fill: parent
	}
}
