package {
	import com.slide.as3.sliso.data.IsoGrid;
	import com.slide.as3.sliso.display.IsoScene;
	import com.slide.as3.sliso.view.IsoView;
	import com.slide.as3.slisotest.Dog;

	import flash.display.Sprite;

	/**
	 * @author ashi
	 */
	public class Sample extends Sprite{
		public function Sample() {
			var scene : IsoScene = new IsoScene();
			
			var grid : IsoGrid = new IsoGrid();
			scene.addChild(grid);
			
			
			var dog : Dog = new Dog();
			scene.addChild(dog);
			dog.x = 35;
			dog.z = 35;
			
			dog = new Dog();
			scene.addChild(dog);
			dog.x = 0;
			dog.z = 35;
			
			var view : IsoView = new IsoView();
			view.addScene(scene);
			
			addChild(view);
			
			view.render();
		}
	}
}
