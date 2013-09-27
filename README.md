# Latte
Latte is a layer of love on top of Starling, Adobe's awesome GPU library for Adobe AIR, it's designed to pack 
helpful features for game development, thus easing the development.

It's focused on beeing easy to learn and with easy to understand documentation.

# Initialization

To create a new Latte game just extend the Game class and override the ```init``` method.

```
package
{
	import latte.core.Game;

	[SWF(framerate="60", width="640", height="480", backgroundColor="0x333333")]
	public class Main extends Game
	{
		public function Main()
		{
			super();
		}
		
		override public function init():void
		{
			// Do initialization here, create scenes and such.
		}
	}
}
```

# Scenes

Latte games are composed of scenes, in your main class, the one who extends ```Game```, you can create and add scenes onto your game, it's important
to note that only one scene can be active as a time.

Scenes are created by extending the Scene class with your own game logic, then, instantiate that scene and add it to the game.

```
package scenes
{
	import latte.core.Scene;

	public class MyScene extends Scene
	{
		public function MyScene()
		{
		}
		
		override public function init():void
		{
			super.init();
			
			// Initialize sprites, maps, etc.
		}
	}
}
```

Once you have created your scene, you can simply instantiate it and add it to the world in our main class.

```
override public function init():void
{
	this.world.addScene("map", new MapScene());
	this.world.active = "map";
}
```