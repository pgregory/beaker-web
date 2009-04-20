class Tag extends neko.db.Object {
	public var id : Int;
	public var name : String;

	static public var manager = new neko.db.Manager<Tag>(Tag);
}

