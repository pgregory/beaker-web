import mtwin.templo.Loader;
import mtwin.templo.Template;

class Upload
{
	static function main()
	{
		Loader.BASE_DIR = "/home/pgregory/haxe_test/web/templates/";
		Loader.TMP_DIR = "/home/pgregory/haxe_test/web/compiled/";
		Loader.MACROS = null;
		Loader.OPTIMIZED = false;
		var t = new Template("upload.mtt");

		var cnx = neko.db.Sqlite.open("/home/pgregory/haxe_test/web/beaker.db");
		neko.db.Manager.cnx = cnx;
		neko.db.Manager.initialize();
		var configs = Config.manager.all();

		var r = t.execute({configs: configs});
		neko.Lib.print(r);
	}
}

