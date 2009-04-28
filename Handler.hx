class Handler extends mtwin.web.Handler<Void> {
	public function new() {
		super();
		free("default", "view.mtt", doView);
		free("upload", "upload.mtt", doUpload);
		free("convert", doConvert);
		free("confirm", "confirm.mtt", doConfirm);
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
		var params = neko.Web.getParams();
		processResultSet(App.tmpPath + params.get("filename"));
		neko.Web.redirect("/index.n");
	}

	public function doConfirm() {
		var params = neko.Web.getMultipart(8000);
		if(haxe.Md5.encode(params.get("password")) == "bf6da5a41799708a33f0cd4dd167e4e2") {
			App.context.results = saveResultSet(params.get("resultset"));
			App.context.tempXml = "results.xml";
		}
	}

	override function prepareTemplate( t:String ) {
		App.template = new mtwin.templo.Loader(t);
	}

	public function saveResultSet(resultset : String) : Dynamic {
		var results : Dynamic = {}
		var filename = App.tmpPath + "results.xml";
		if(neko.FileSystem.exists(filename)) {
			neko.FileSystem.deleteFile(filename);
		}
		var fout = neko.io.File.write(filename, false);
		fout.writeString(resultset);
		fout.close();
		var x : Xml = Xml.parse(resultset).elementsNamed("result_sets").next();
		if(x != null) {
			var config = x.get("config");
			results.config = {};
			results.config.name = config;
			var dbConfig : List<Config> = Config.manager.search({ name : config}, true);
			results.config.exists = !dbConfig.isEmpty();
			results.config.tags = new List<Dynamic>(); 
			for(resultSet in x.elementsNamed("result_set")) {
				var tag = resultSet.get("tag");
				var dbTag : List<Tag> = Tag.manager.search({ name : tag}, true);
				var resultstag : Dynamic = {};
				resultstag.name = tag;
				resultstag.exists = !dbTag.isEmpty();
				resultstag.values = new List<Dynamic>();
				for(result in resultSet.elementsNamed("result")) {
					var test = result.get("test");	
					var dbTest : List<Test> = Test.manager.search({ title : test}, true);
					var resultvalues : Dynamic = {};
					resultvalues.test = {};
					resultvalues.test.name = test;	
					resultvalues.test.exists = !dbTest.isEmpty();
					var time = result.get("time");	
					resultvalues.time = time;
					// Check if this test result already exists.
					resultvalues.exists = (!dbTest.isEmpty() && !dbConfig.isEmpty() && !dbTag.isEmpty()) && !Result.manager.search({ config_id : dbConfig.first().id, tag_id : dbTag.first().id, test_id : dbTest.first().id}, false).isEmpty();
					resultstag.values.add(resultvalues);
				}
				results.config.tags.add(resultstag);
			}
		}
		return results;
	}

	public function processResultSet(filename : String) {
		var resultset : String = neko.io.File.getContent(filename);
		var x : Xml = Xml.parse(resultset);
		var result_sets : Xml = x.elementsNamed("result_sets").next();
		if(x != null) {
			var config = result_sets.get("config");

			var dbConfigs : List<Config> = Config.manager.search({ name : config}, true);
			var dbConfig : Config = null;
			if(dbConfigs.isEmpty()) {
				for(config_entry in x.elementsNamed("config")) {
					if( config_entry.get("name") == config) {
						dbConfig = new Config();
						dbConfig.name = config;
						dbConfig.owner = config_entry.get("owner");
						dbConfig.model = config_entry.get("model");
						dbConfig.processor = config_entry.get("processor");
						dbConfig.processor_count = Std.parseInt(config_entry.get("processor_count"));
						dbConfig.memory = Std.parseInt(config_entry.get("memory"));
						dbConfig.os = config_entry.get("os");
						dbConfig.compiler = config_entry.get("compiler");
						dbConfig.insert();
					}
				}
			} else {
				dbConfig = dbConfigs.first();
			}
			for(resultSet in result_sets.elementsNamed("result_set")) {
				var tag = resultSet.get("tag");
				var dbTags : List<Tag> = Tag.manager.search({ name : tag}, true);
				var dbTag : Tag = null;
				if(dbTags.isEmpty()) {
					for(tag_entry in x.elementsNamed("tag")) {
						if( tag_entry.get("name") == tag) {
							dbTag = new Tag();
							dbTag.name = tag;
							dbTag.position = Std.parseInt(tag_entry.get("position"));
							dbTag.insert();
						}
					}
				} else {
					dbTag = dbTags.first();
				}
				for(result in resultSet.elementsNamed("result")) {
					var test = result.get("test");	
					var dbTests : List<Test> = Test.manager.search({ title : test}, true);
					var dbTest : Test = null;
					if(dbTests.isEmpty()) {
						for(test_entry in x.elementsNamed("test")) {
							if(test_entry.get("title") == test) {
								dbTest = new Test();
								dbTest.title = test;
								dbTest.notes = test_entry.firstChild().nodeValue;
								dbTest.label = test_entry.get("label");
								dbTest.insert();
							}
						}
					} else {
						dbTest = dbTests.first();
					}
					var time = result.get("time");	
					var existingResult : List<Result> = Result.manager.search({config_id : dbConfig.id, tag_id : dbTag.id, test_id : dbTest.id});
					if(existingResult.isEmpty()) {
						var newResult : Result = new Result();
						newResult.config = dbConfig;
						newResult.tag = dbTag;
						newResult.test = dbTest;
						newResult.time = Std.parseFloat(time);
						newResult.insert();
					} else {
						existingResult.first().time = Std.parseFloat(time);
						existingResult.first().update();
					}
				}
			}
		}
	}
}
