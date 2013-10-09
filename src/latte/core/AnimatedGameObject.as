package latte.core
{	
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * An animated game object.
	 * Each animated game object can have many different animations.
	 */
	public class AnimatedGameObject extends GameObject
	{
		private var _animations:Dictionary;
		private var _atlas:TextureAtlas;
		private var _currentAnimation:String;
		private var _idle:Boolean;
		
		public function AnimatedGameObject(atlas:TextureAtlas)
		{
			var empty:Texture = Texture.empty(32, 32);
			super(empty);
			
			_animations = new Dictionary();
			_atlas = atlas;
			_currentAnimation = null;
			_idle = false;
		}
		
		/**
		 * Helper function for Animated Game Objects. Easily enables the creation of a TextureAtlas
		 * based on a mapfile instead of an XML, useful for other spritesheet packers such as
		 * SpritesheetPacker <http://spritesheetpacker.codeplex.com/>, which are able to export with the 
		 * following format:
		 * 
		 * imageName = x y width height
		 * anotherImage = x y width height
		 */
		public static function getAtlasFromMapfile(texture:Texture, mapFile:String):TextureAtlas
		{
			// Generate Starling XML
			var xml:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><TextureAtlas>";
			var lines:Array = mapFile.split("\n");
			for each(var line:String in lines) {
				// Ignore invalid line
				if(line.indexOf("=") == -1) {
					continue;
				}
				
				// Create XML element
				var imageData:Array = line.split("=");
				var name:String = trim(imageData[0]);
				var values:Array = trim(imageData[1]).split(" ");
				var x:int = int(trim(values[0]));
				var y:int = int(trim(values[1]));
				var width:int = int(trim(values[2]));
				var height:int = int(trim(values[3]));
				xml += "<SubTexture name=\"" + name + "\" x=\"" + x + "\" y=\"" + y + "\" width=\"" + width + "\" height=\"" + height + "\"/>";
			}
			xml += "</TextureAtlas>";
			
			// Create atlas from that XML
			return new TextureAtlas(texture, new XML(xml));
		}
		
		private static function trim(str:String):String
		{
			if(str == null) {
				return null;
			}

			return str.replace(/^\s+|\s+$/g, '');
		}
	
		
		public function get idle():Boolean
		{
			return _idle;
		}

		public function set idle(value:Boolean):void
		{
			_idle = value;
			_animations[_currentAnimation].idle = value;
		}

		public function get currentAnimation():String
		{
			return _currentAnimation;
		}

		public function set currentAnimation(value:String):void
		{
			_currentAnimation = value;
			onAnimationAdvanced();
		}

		public function addAnimation(name:String, filter:String, fps:Number=12, idleFrame:String = null):void
		{
			// Create a new animation
			var frames:Vector.<Texture> = _atlas.getTextures(filter);
			var defaultFrame:Texture;
			if(idleFrame != null) {
				defaultFrame = _atlas.getTexture(idleFrame);
			} else {
				defaultFrame = frames[0];
			}

			_animations[name] = new Animation(frames, fps, defaultFrame);
			_animations[name].addEventListener(GameEvent.ANIMATED_GAME_OBJECT_ADVANCED, onAnimationAdvanced);
		}
		
		/**
		 * When the current animation changes, update the texture of this object
		 */
		private function onAnimationAdvanced():void
		{
			texture = _animations[_currentAnimation].currentFrame;
			readjustSize();
		}
		
		public function update(delta:Number):void
		{
			_animations[_currentAnimation].update(delta);
		}
	}
}

import latte.core.GameEvent;

import starling.events.EventDispatcher;
import starling.textures.Texture;

/**
 * Helper class for the Animated Game Object, represents an Animation.
 * An animation is defined by a list of textures which will then be displayed in that order.
 * It also has a Frames Per Second (FPS) number and a texture which will be used when the animation
 * is in IDLE mode.
 */
internal class Animation extends EventDispatcher
{
	private var _elapsed:Number;
	private var _elapsedLimit:Number;
	private var _idleFrame:Texture;
	private var _currentFrame:int;
	private var _textures:Vector.<Texture>;
	private var _idle:Boolean;
	
	public function Animation(textures:Vector.<Texture>, fps:Number, idleFrame:Texture)
	{
		_elapsed = 0;
		_elapsedLimit = 1000 / fps;
		_currentFrame = 0;
		_textures = textures;
		_idleFrame = idleFrame;
	}
	
	public function get idle():Boolean
	{
		return _idle;
	}

	public function set idle(value:Boolean):void
	{
		_idle = value;
	}

	public function update(delta:Number):void
	{
		_elapsed += delta * 1000;
		if(_elapsed >= _elapsedLimit) {
			_elapsed = 0;
			advance();
		}
	}
	
	/**
	 * Advances the animation frame
	 */
	private function advance():void
	{
		_currentFrame = (_currentFrame + 1) % _textures.length;
		this.dispatchEvent(new GameEvent(GameEvent.ANIMATED_GAME_OBJECT_ADVANCED));
	}
	
	/**
	 * Gets the current frame as a texture
	 */
	public function get currentFrame():Texture
	{
		return _idle ? _idleFrame : _textures[_currentFrame];
	}
}