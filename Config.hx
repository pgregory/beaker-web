class Config extends neko.db.Object {
	public var id : Int;
	public var name : String;
	public var owner : String;
	public var model : String;
	public var processor : String;
	public var processor_count : Int;
	public var memory : Int;
	public var os : String;
	public var compiler : String;

	public function getResult(tag_id : Int, test_id :Int) : Result {
		var results = Result.manager.search({config_id : id, tag_id : tag_id, test_id : test_id});
		if(results.isEmpty())
			return null;
		else
			return results.first();
	}
	
	public function faster(tag : Tag, test : Test) : Int {
		var prev : Tag = tag.previousTag();
		if(prev == null)
			return 0;

		var prevResult : Result = getResult(prev.id, test.id);
		while( prev != null && prevResult == null ) { 
			var prevResult = getResult(prev.id, test.id);
			prev = prev.previousTag();
		}
		if(prevResult != null) {
			var currResult = getResult(tag.id, test.id);
			if(prevResult != null && currResult != null) {
				if(prevResult.time > currResult.time) {
					return 1;
				} else if(prevResult.time < currResult.time) {
					return -1;
				} else {
					return 0;
				}
			}
		}
		return 2;
	}

	public static var manager = new neko.db.Manager<Config>(Config);
}
