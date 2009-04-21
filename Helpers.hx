class Helpers {
	public function new() {
	}

	public function truncatePercentage(p : Float) : String {
		return Std.string(p).substr(0, Std.string(p).indexOf('.')+3);
	}
}
