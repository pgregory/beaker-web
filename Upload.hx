import mtwin.templo.Loader;
import mtwin.templo.Template;

class Upload
{
	static function main()
	{
		Loader.BASE_DIR = neko.Web.getCwd() + "templates/";
		Loader.TMP_DIR = neko.Web.getCwd() + "compiled/";
		Loader.MACROS = null;
		Loader.OPTIMIZED = false;
		var t = new Template("upload.mtt");

		var cnx = neko.db.Sqlite.open(neko.Web.getCwd() + "beaker.db");
		neko.db.Manager.cnx = cnx;
		neko.db.Manager.initialize();
		var configs = Config.manager.all();

		var r = t.execute({configs: configs});
		neko.Lib.print(r);
	}
}

