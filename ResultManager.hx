class ResultManager extends neko.db.Manager<Result> {
	public function new() {
		super(Result);
	}

	public function findByConfigAndTag(id : Int, tag_id : Int) : List<Result> {
		return objects(select("config_id = "+id+" and tag_id = "+tag_id), true );
	}

	public function findByConfig(config_id : Int) : List<Result> {
		return objects(select("config_id = "+config_id), true );
	}
}
