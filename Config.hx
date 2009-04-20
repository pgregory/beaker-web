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

	public function resultsByTag(tag_id : Int) : Hash<Result> {
		var results = Result.manager.findByConfigAndTag(id, tag_id);
		var resultSet : Hash<Result> = new Hash<Result>();
		for(result in results) {
			resultSet.set(result.test.title, result);
		}
		return resultSet;
	}

	public static var manager = new neko.db.Manager<Config>(Config);
}
