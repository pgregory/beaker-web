class Handler extends mtwin.web.Handler<Void> {
	public function new() {
		super();
		free("default", "view.mtt", doView);
		free("upload", "upload.mtt", doUpload);
		free("convert", doConvert);
	}

	public function doView() {
		App.context.helpers = new Helpers();
		App.context.configs = Config.manager.all();
		App.context.tests = Test.manager.all();
		App.context.tags = Tag.manager.objects("SELECT * FROM Tag ORDER BY POSITION", true);
	}

	public function doUpload() {
		App.context.configs = Config.manager.all();
	}

	public function doConvert() {
		var params = neko.Web.getMultipart(80000);
		if(haxe.Md5.encode(params.get("password")) == "bf6da5a41799708a33f0cd4dd167e4e2") {
			processResultSet(params.get("config"), params.get("resultset"));
			App.context.alert = "Successfully uploaded result set";
		} else {
			App.context.alert = "Failed: Invalid password";
		}
		neko.Web.redirect("http://beaker.aqsis.org/index.n");
	}

	override function prepareTemplate( t:String ) {
		App.template = new mtwin.templo.Loader(t);
	}

	public function processResultSet(config : String, resultset : String) {
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
	}
}
