class Test extends neko.db.Object {
	public var id : Int;
	public var title : String;
	public var notes : String;
	public var label : String;

	static public var manager = new neko.db.Manager<Test>(Test);
}
