package latte.core
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import latte.util.Vector2;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * Loads a tilemap from Tiled <http://www.mapeditor.org/>
	 * The first layer will be the one which is used to draw the map.
	 * The second layer if exists represent solid tiles.
	 */
	public class Tilemap extends Image
	{
		// For now, all solids are saved in a list, TODO: Use binary tree
		protected var _solids:Vector.<Rectangle>;
		
		// The map data object
		protected var _mapdata:Object;
		protected var _maparray:Array;
		protected var _mapproperties:Object;
		
		public function Tilemap(map:String, tiles:BitmapData, debugMode:Boolean = true)
		{
			// Initialize the solids vector
			_solids = new Vector.<Rectangle>();
			
			// Use the JSON class and parse our map into an object
			_mapdata = JSON.parse(map);
			
			/* First of all, we need to read the map data exported from Tiled, 
			we'll read only the JSON format for now and we won't support
			all of tiled map features to keep it simple. 
			As we need to call super() let's first get width and height */
			var width:int = _mapdata.tilewidth * _mapdata.width;
			var height:int = _mapdata.tileheight * _mapdata.height;
			
			// Let's create the solids BitmapData, transparent
			var solidsBitmap:BitmapData = new BitmapData(width, height, true, 0x00FFFFFF);
			
			// Save the map properties
			_mapproperties = _mapdata.tilesets[0].tileproperties;
			
			/* Now, let's use the first layer to generate the map, initialize
			some variables used in the loop */
			_maparray = _mapdata.layers[0].data;
			var collision_layer:Array = null;
			if(_mapdata.layers.length > 1) {
				collision_layer = _mapdata.layers[1].data;
			}
			var idx:int = 0;
			var spacing:int = _mapdata.tilesets[0].spacing;
			var canvas:BitmapData = new BitmapData(width, height, false, 0x000000);
			var map_spaced_width:int = int(tiles.width / (_mapdata.tilewidth + spacing));
			
			for(var j:int = 0, map_height:int = _mapdata.height; j < map_height; j += 1) {
				for(var i:int = 0, map_width:int = _mapdata.width; i < map_width; i += 1) {
					/* Get the number of the tile in the current index and
					also force the tilenum to start from 0 for easier math */
					var tile_num:int = _maparray[idx] - 1;
					
					// If it's invisible just skip
					if(tile_num < 0) {
						continue;
					}
					
					/* Now we need to find the starting point of the tile number
					and create a rect with the location on the tilemap source
					by doing (tile_num % map_width_in_tiles) we get the X coordinate */
					var start_x:int = tile_num % map_spaced_width;
					// By doing (tile_num / map_width_in_tiles) we get the Y coordinate
					var start_y:int = int(tile_num / map_spaced_width);
					
					// Find out locations for tile in canvas
					var rect:Rectangle = new Rectangle(start_x * (_mapdata.tilewidth + spacing), start_y * (_mapdata.tileheight + spacing), _mapdata.tilewidth, _mapdata.tileheight);
					var dest:Point = new Point(i * _mapdata.tilewidth - spacing, j * _mapdata.tileheight - spacing);
					
					// We have the rectangle, let's see if it's a collisionable rectangle
					if (collision_layer != null && collision_layer[idx] != 0) {
						/* If the collision layer is defined and it has a block in this index
						add this rectable to solids vector */
						_solids.push(new Rectangle(dest.x, dest.y, _mapdata.tilewidth, _mapdata.tileheight));
						// Also draw the solid in the solids BitmapData
						solidsBitmap.copyPixels(new BitmapData(_mapdata.tilewidth, _mapdata.tileheight, true, 0x33FF0000), new Rectangle(0, 0, _mapdata.tilewidth, _mapdata.tileheight), new Point(dest.x, dest.y));
					}
					
					// Draw the tile to our canvas
					canvas.copyPixels(tiles, rect, dest);
					
					/* The index is incremented on every loop because Tiled stores the map data in a single dimension
					array, we later use modulus and divisions to get the (x, y) positions */
					idx++;
				}
			}
			
			// If debug mode, copy the solids bitmapdata on top of our final map
			if(debugMode) {
				canvas.copyPixels(solidsBitmap, new Rectangle(0, 0, solidsBitmap.width, solidsBitmap.height), new Point(0, 0));
			}
			
			// Finally create a texture
			var texture:Texture = Texture.fromBitmapData(canvas);
			super(texture);
		}
		
		/**
		 * Whether an object collides with a solid in this map
		 */
		public function collides(obj:DisplayObject):Boolean
		{
			var rect:Rectangle = new Rectangle(obj.x, obj.y, obj.width, obj.height);
			for(var solid:Rectangle in _solids) {
				if(solid.intersects(rect)) {
					return true;
				}
			}
			
			return false;
		}
		
		public function getTileAt(x:Number, y:Number):int
		{
			var x_in_tiles:int = int(x / _mapdata.tilewidth);
			var y_in_tiles:int = int(y / _mapdata.tileheight);
			// To get the index we transform a point(x,y) to a scalar by doing
			// (y * map_width + x), as we store the map data in a single dimensional array
			var idx:int = y_in_tiles * int(_mapdata.width) + x_in_tiles;
			return _maparray[idx];
		}
		
		public function getTilePropertiesAt(x:Number, y:Number):Object
		{
			if(_mapproperties == null) {
				return null;
			}
			
			return _mapproperties[getTileAt(x, y)];
		}
	}
}