class Result extends neko.db.Object {
	public var id : Int;
	public var time : Float;
	private var config_id : Int;
	private var test_id : Int;
	private var tag_id : Int;
	static function RELATIONS() {
		return [{ prop : "config", key : "config_id", manager : Config.manager},
				{ prop : "test", key : "test_id", manager : Test.manager},
				{ prop : "tag", key : "tag_id", manager : Tag.manager},
				];
	}
	public var test(dynamic,dynamic) : Test;
	public var config(dynamic,dynamic) : Config;
	public var tag(dynamic,dynamic) : Tag;

	public function timeAsString() : String {
		var d : Date = Date.fromTime(DateTools.seconds(time));
		var result : String = "";
		if(d.getMinutes() > 0) {
			result = d.getMinutes() + "m";
		}
		return result + (time - (d.getMinutes()*60)) + "s";
	}

	static public var manager = new ResultManager();
}
	

