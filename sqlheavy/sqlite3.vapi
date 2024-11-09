[CCode(cheader_filename = "sqlite3.h")]
namespace Sqlite {
	[Compact]
	[CCode(cname = "sqlite3_blob", free_function = "sqlite3_blob_close", cprefix = "sqlite3_blob_")]
	private class Blob {
		public static int open(Sqlite.Database db, string db_name, string table, string column, int64 row, int flags, out Blob blob);

		public int bytes();
		[DestroysInstance]
		public int close();
		public int read(uint8[] buffer, int offset);
	}
}
