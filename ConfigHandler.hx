class ConfigHandler extends mtwin.web.Handler<Void> {
	public function new() {
		super();
		free("new", "newconfig.mtt", doNewConfig);
		free("create",  doCreateConfig);
	}

	public function doNewConfig() {
	}

	public function doCreateConfig() {
		var params = neko.Web.getParams();
		if(haxe.Md5.encode(params.get("password")) == "bf6da5a41799708a33f0cd4dd167e4e2") {
			var names : Array<String> = neko.Web.getParamValues("name");
			var owners : Array<String> = neko.Web.getParamValues("owner");
			var models : Array<String> = neko.Web.getParamValues("model");
			var processors : Array<String> = neko.Web.getParamValues("processor");
			var processor_counts : Array<String> = neko.Web.getParamValues("processor_count");
			var memorys : Array<String> = neko.Web.getParamValues("memory");
			var oss : Array<String> = neko.Web.getParamValues("os");
			var compilers : Array<String> = neko.Web.getParamValues("compiler");
			if(names.length == owners.length &&
			   names.length == models.length &&
			   names.length == processors.length &&
			   names.length == processor_counts.length &&
			   names.length == memorys.length &&
			   names.length == oss.length &&
			   names.length == compilers.length)
			{
				for(i in 0...names.length) {
					var dbConfig : Config = new Config();
					dbConfig.name = names[i];
					dbConfig.owner = owners[i];
					dbConfig.model = models[i];
					dbConfig.processor = processors[i];
					dbConfig.processor_count = Std.parseInt(processor_counts[i]);
					dbConfig.memory = Std.parseInt(memorys[i]);
					dbConfig.os = oss[i];
					dbConfig.compiler = compilers[i];
					dbConfig.insert();
				}
			}
		}
		neko.Web.redirect("/index.n");
	}

	override function prepareTemplate( t:String ) {
		App.template = new mtwin.templo.Loader(t);
	}

}
