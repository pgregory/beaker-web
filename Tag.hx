class Tag extends neko.db.Object {
	public var id : Int;
	public var name : String;
	public var position : Int;

	static public var manager = new neko.db.Manager<Tag>(Tag);

	public function previousTag() : Tag {
		return manager.object("SELECT * FROM Tag WHERE position < "+position+" ORDER BY position DESC", true);
	}
}

