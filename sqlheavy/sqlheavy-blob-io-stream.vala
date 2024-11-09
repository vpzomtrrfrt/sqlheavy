namespace SQLHeavy {
	private class BlobIOState {
		public Sqlite.Blob? blob;
		public int length;
		public int offset = 0;
	}

	public class BlobIOStream {
		private BlobIOState state;

		private BlobInputStream _input_stream;

		public GLib.InputStream input_stream {
			get {
				return _input_stream;
			}
		}

		internal BlobIOStream(owned Sqlite.Blob blob) {
			state = new BlobIOState();

			state.blob = (owned) blob;
			state.length = state.blob.bytes();

			_input_stream = new BlobInputStream(state);
		}
	}

	/**
	 * An input stream that takes its content from a SQLite blob.
	 */
	public class BlobInputStream : GLib.InputStream {
		private BlobIOState state;

		internal BlobInputStream(BlobIOState state) {
			this.state = state;
		}

		public override bool close(GLib.Cancellable? cancellable = null) throws GLib.IOError {
			if(state.blob == null) return true;

			var ec = state.blob.close();
			if(ec != Sqlite.OK) throw new GLib.IOError.FAILED(sqlite_errstr(ec));
			state.blob = null;

			return true;
		}

		public override ssize_t read(uint8[] buffer, Cancellable? cancellable = null) throws GLib.IOError {
			if(state.blob == null) throw new GLib.IOError.CLOSED("Blob has been closed");

			int remaining = state.length - state.offset;
			if(remaining > buffer.length) {
				var ec = state.blob.read(buffer, state.offset);
				if(ec != Sqlite.OK) throw new GLib.IOError.FAILED(sqlite_errstr(ec));
				state.offset += buffer.length;

				return buffer.length;
			}
			else if(remaining == 0) {
				return 0;
			}
			else {
				var ec = state.blob.read(buffer[:remaining], state.offset);
				if(ec != Sqlite.OK) throw new GLib.IOError.FAILED(sqlite_errstr(ec));
				state.offset += remaining;

				return remaining;
			}
		}
	}
}
