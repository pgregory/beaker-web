class Convert
{
	static function main()
	{
		var params = neko.Web.getMultipart(80000);
		var alert : String = "";
		if(haxe.Md5.encode(params.get("password")) == "bf6da5a41799708a33f0cd4dd167e4e2") {
			processResultSet(params.get("config"), params.get("resultset"));
		} else {
			alert = "<div class=\"notification\">Failed: Invalid password</div>";
		}
		neko.Web.redirect("http://beaker.aqsis.org/Main.n");
	}

	static function processResultSet(config : String, resultset : String) {
		var cnx = neko.db.Sqlite.open(neko.Web.getCwd() + "beaker.db");

		neko.db.Manager.cnx = cnx;
		neko.db.Manager.initialize();
	
		var x : Xml = Xml.parse(resultset).elementsNamed("result_sets").next();
		if(x != null) {
			if(x.get("config") != "" && config == "")
				config = x.get("config");

			var dbConfig : List<Config> = Config.manager.search({ name : config}, true);
			if(!dbConfig.isEmpty()) {
				for(resultSet in x.elementsNamed("result_set")) {
					var tag = resultSet.get("tag");
					var dbTag : List<Tag> = Tag.manager.search({ name : tag}, true);
					if(!dbTag.isEmpty()) {
						for(result in resultSet.elementsNamed("result")) {
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
				}
			} else {
				neko.Lib.print("Could not find specified config");
			}
		}

		neko.db.Manager.cleanup();
		cnx.close();
	}
}

