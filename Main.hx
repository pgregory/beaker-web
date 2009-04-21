import mtwin.templo.Loader;
import mtwin.templo.Template;

class Main
{
	static function main()
	{
		Loader.BASE_DIR = neko.Web.getCwd() + "templates/";
		Loader.TMP_DIR = neko.Web.getCwd() + "compiled/";
		Loader.MACROS = "macros.mtt";
		Loader.OPTIMIZED = false;

		var t = new Template("view.mtt");
		var cnx = neko.db.Sqlite.open(neko.Web.getCwd() + "beaker.db");

		neko.db.Manager.cnx = cnx;
		neko.db.Manager.initialize();

		var helpers = new Helpers();
	
		var configs : List<Config> = Config.manager.all();
		var tests : List<Test> = Test.manager.all();
		var tags : List<Tag> = Tag.manager.objects("SELECT * FROM Tag ORDER BY POSITION", true);
		var r = t.execute({helpers : helpers, configs: configs, tests: tests, tags: tags});
		neko.Lib.print(r);

		neko.db.Manager.cleanup();
		cnx.close();
	}
}
