class TagHandler extends mtwin.web.Handler<Void> {
	public function new() {
		super();
		free("new", "newtag.mtt", doNewTag);
		free("create",  doCreateTag);
	}

	public function doNewTag() {
	}

	public function doCreateTag() {
		var params = neko.Web.getParams();
		if(haxe.Md5.encode(params.get("password")) == "bf6da5a41799708a33f0cd4dd167e4e2") {
			var names : Array<String> = neko.Web.getParamValues("name");
			var positions : Array<String> = neko.Web.getParamValues("position");
			if(names.length == positions.length)
			{
				for(i in 0...names.length) {
					var dbTag : Tag = new Tag();
					dbTag.name = names[i];
					dbTag.position = Std.parseInt(positions[i]);
					dbTag.insert();
				}
			}
		}
		neko.Web.redirect("/index.n");
	}

	override function prepareTemplate( t:String ) {
		App.template = new mtwin.templo.Loader(t);
	}

}
