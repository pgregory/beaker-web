import mtwin.templo.Loader;
import mtwin.templo.Template;

class Convert
{
	static function main()
	{
		neko.Lib.print(neko.Web.getMethod());
		neko.Lib.print(neko.Web.getMultipart(80000));

		Loader.BASE_DIR = "/home/pgregory/haxe_test/web/templates/";
		Loader.TMP_DIR = "/home/pgregory/haxe_test/web/compiled/";
		Loader.MACROS = null;
		Loader.OPTIMIZED = false;
		var t = new Template("upload.mtt");
		var r = t.execute({});
		neko.Lib.print(r);

		var fname = "resultset.xml";
	}

	function processResultSet(fname : String) {
		var fileContent = neko.io.File.getContent(fname);
		
		var cnx = neko.db.Sqlite.open("beaker.db");

		neko.db.Manager.cnx = cnx;
		neko.db.Manager.initialize();
	
		var x : Xml = Xml.parse(fileContent).firstElement();
		
		var config = x.get("config");
		var tag = x.get("tag");

		neko.Lib.print(config + " - " + tag + "\n");
		var dbConfig : List<Config> = Config.manager.search({ name : config}, true);
		if(!dbConfig.isEmpty()) {
			var dbTag : List<Tag> = Tag.manager.search({ name : tag}, true);
			if(!dbTag.isEmpty()) {
				for(result in x.elementsNamed("result")) {
					var test = result.get("test");	
					var dbTest : List<Test> = Test.manager.search({ title : test}, true);
					if(!dbTest.isEmpty()) {
						var time = result.get("time");	
						var newResult : Result = new Result();
						newResult.config = dbConfig.first();
						newResult.tag = dbTag.first();
						newResult.test = dbTest.first();
						newResult.time = Std.parseFloat(time);
						newResult.insert();
					}
				}
			} else {
				neko.Lib.print("Could not find specified tag");
			}
		} else {
			neko.Lib.print("Could not find specified config");
		}

		neko.db.Manager.cleanup();
		cnx.close();
	}
}

