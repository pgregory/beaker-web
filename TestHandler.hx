class TestHandler extends mtwin.web.Handler<Void> {
	public function new() {
		super();
		free("new", "newtest.mtt", doNewTest);
		free("create",  doCreateTest);
	}

	public function doNewTest() {
	}

	public function doCreateTest() {
		var params = neko.Web.getParams();
		if(haxe.Md5.encode(params.get("password")) == "bf6da5a41799708a33f0cd4dd167e4e2") {
			var titles : Array<String> = neko.Web.getParamValues("title");
			var labels : Array<String> = neko.Web.getParamValues("label");
			var notes : Array<String> = neko.Web.getParamValues("notes");
			if(titles.length == labels.length &&
			   titles.length == notes.length)
			{
				for(i in 0...titles.length) {
					var dbTest : Test = new Test();
					dbTest.title = titles[i];
					dbTest.label = labels[i];
					dbTest.notes = notes[i];
					dbTest.insert();
				}
			}
		}
		neko.Web.redirect("/index.n");
	}

	override function prepareTemplate( t:String ) {
		App.template = new mtwin.templo.Loader(t);
	}

}
