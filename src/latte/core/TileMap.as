package latte.core
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
		
		public function Tilemap(map:String, tiles:BitmapData, debugMode:Boolean = true)
		{
			// Initialize the solids vector
			_solids = new Vector.<Rectangle>();
			
			// Use the JSON class and parse our map into an object
			var data:Object = JSON.parse(map);
			
			/* First of all, we need to read the map data exported from Tiled, 
			we'll read only the JSON format for now and we won't support
			all of tiled map features to keep it simple. 
			As we need to call super() let's first get width and height */
			var width:int = data.tilewidth * data.width;
			var height:int = data.tileheight * data.height;
			
			// Let's create the solids BitmapData, transparent
			var solidsBitmap:BitmapData = new BitmapData(width, height, true, 0x00FFFFFF);
			
			/* Now, let's use the first layer to generate the map, initialize
			some variables used in the loop */
			var layer:Array = data.layers[0].data;
			var collision_layer:Array = null;
			if(data.layers.length > 1) {
				collision_layer = data.layers[1].data;
			}
			var idx:int = 0;
			var spacing:int = data.tilesets[0].spacing;
			var canvas:BitmapData = new BitmapData(width, height, false, 0x000000);
			var map_spaced_width:int = int(tiles.width / (data.tilewidth + spacing));
			
			for(var j:int = 0, map_height:int = data.height; j < map_height; j += 1) {
				for(var i:int = 0, map_width:int = data.width; i < map_width; i += 1) {
					/* Get the number of the tile in the current index and
					also force the tilenum to start from 0 for easier math */
					var tile_num:int = layer[idx] - 1;
					
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
					var rect:Rectangle = new Rectangle(start_x * (data.tilewidth + spacing), start_y * (data.tileheight + spacing), data.tilewidth, data.tileheight);
					var dest:Point = new Point(i * data.tilewidth - spacing, j * data.tileheight - spacing);
					
					// We have the rectangle, let's see if it's a collisionable rectangle
					if (collision_layer != null && collision_layer[idx] != 0) {
						/* If the collision layer is defined and it has a block in this index
						add this rectable to solids vector */
						_solids.push(new Rectangle(dest.x, dest.y, data.tilewidth, data.tileheight));
						// Also draw the solid in the solids BitmapData
						solidsBitmap.copyPixels(new BitmapData(data.tilewidth, data.tileheight, true, 0x33FF0000), new Rectangle(0, 0, data.tilewidth, data.tileheight), new Point(dest.x, dest.y));
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
	}
}