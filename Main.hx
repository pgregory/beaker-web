import mtwin.templo.Loader;
import mtwin.templo.Template;

class Main
{
	static function main()
	{
		Loader.BASE_DIR = "/home/pgregory/haxe_test/web/templates/";
		Loader.TMP_DIR = "/home/pgregory/haxe_test/web/compiled/";
		Loader.MACROS = null;
		Loader.OPTIMIZED = false;
		var t = new Template("view.mtt");
		var cnx = neko.db.Sqlite.open("beaker.db");

		neko.db.Manager.cnx = cnx;
		neko.db.Manager.initialize();
	
		var configs : List<Config> = Config.manager.all();
		var tests : List<Test> = Test.manager.all();
		var tags : List<Tag> = Tag.manager.all();
		var r = t.execute({configs: configs, tests: tests, tags: tags});
		neko.Lib.print(r);

		neko.db.Manager.cleanup();
		cnx.close();
	}
}
