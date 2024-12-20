namespace SQLHeavy {
  /**
   * A record
   */
  public interface Record : GLib.Object {
    /**
     * The number of fields in the result set.
     */
    public abstract int field_count { get; }

    /**
     * Fetch the field name for the specified index
     *
     * @param field index of field to fetch
     * @return the name of the field
     * @see field_index
     * @see field_names
     */
    public abstract string field_name (int field = 0) throws SQLHeavy.Error;

    /**
     * Fetch the index for the specified field name
     *
     * @param field field name
     * @return the index of the field
     * @see field_name
     */
    public abstract int field_index (string field) throws SQLHeavy.Error;

    /**
     * Fetch the field names for the results
     *
     * @return an array of field names
     * @see field_name
     */
    public virtual string[] field_names () {
      try {
        var fields = new string[this.field_count];

        for ( var i = 0 ; i < fields.length ; i++ )
          fields[i] = this.field_name (i);

        return fields;
      }
      catch ( SQLHeavy.Error e ) {
        /* The only thing that throws an error is the field_name
         * call, and since we know 0 <= argument < field_count, it
         * should never fail. */
        GLib.assert_not_reached ();
      }
    }

    /**
     * Get field type
     *
     * @param field the field index
     * @return the datatype of the field
     */
    public abstract GLib.Type field_type (int field = 0) throws SQLHeavy.Error;

    /**
     * Return a field from result.
     *
     * @param field the index of the field to return.
     * @return the value of the field
     * @see get
     * @see fetch_row
     */
    public abstract GLib.Value fetch (int field = 0) throws SQLHeavy.Error;

    /**
     * Fetch a field from the result by name
     *
     * @param field field name
     * @return the field value
     * @see fetch
     */
    public virtual GLib.Value? get (string field) throws SQLHeavy.Error {
      return this.fetch (this.field_index (field));
    }

    /**
     * Fetch a row in a foreign table
     *
     * @param field the index of the field to return
     * @return the value of the field
     * @see get_foreign_row
     */
    public abstract SQLHeavy.Row fetch_foreign_row (int field = 0) throws SQLHeavy.Error;

    /**
     * Fetch a row in a foreign table
     *
     * @param field the name of the field to return
     * @return the value of the field
     * @see fetch_foreign_row
     */
    public virtual SQLHeavy.Row get_foreign_row (string field) throws SQLHeavy.Error {
      return this.fetch_foreign_row (this.field_index (field));
    }

    /**
     * Return a row from result
     *
     * @return the current row
     * @see fetch
     */
    public virtual GLib.ValueArray fetch_row () throws SQLHeavy.Error {
      var fields = this.field_count;
      var data = new GLib.ValueArray (fields);

      for ( var c = 0 ; c < fields ; c++ )
        data.append (this.fetch (c));

      return data;
    }

    /**
     * Fetch a field from the result, and attempt to transform it if necessary
     *
     * @param requested_type the requested type
     * @param field the field_index
     * @return the field value
     * @see fetch
     */
    public virtual GLib.Value fetch_with_type (GLib.Type requested_type, int field = 0) throws SQLHeavy.Error {
      var val = this.fetch (field);
      if ( val.holds (requested_type) )
        return val;

      var transformed_val = GLib.Value (typeof (string));
      if ( val.transform (ref transformed_val) )
        return transformed_val;

      throw new SQLHeavy.Error.DATA_TYPE ("Unable to transform %s to %s.", val.type ().name (), requested_type.name ());
    }

    /**
     * Fetch a field from the result as a string
     *
     * @param field field index
     * @return the field value
     * @see get_string
     * @see fetch
     */
    public virtual string? fetch_string (int field = 0) throws SQLHeavy.Error {
      return this.fetch_with_type (typeof (string), field).get_string ();
    }

    /**
     * Fetch a field from the result as a string by name
     *
     * @param field field name
     * @return the field value
     * @see fetch_string
     * @see fetch
     */
    public virtual string? get_string (string field) throws SQLHeavy.Error {
      return this.fetch_string (this.field_index (field));
    }

    /**
     * Fetch a field from the result as an integer
     *
     * @param field field index
     * @return the field value
     * @see get_int
     * @see fetch
     */
    public virtual int fetch_int (int field = 0) throws SQLHeavy.Error {
      return this.fetch_with_type (typeof (int), field).get_int ();
    }

    /**
     * Fetch a field from the result as an integer by name
     *
     * @param field field name
     * @return the field value
     * @see fetch_int
     * @see fetch
     */
    public virtual int get_int (string field) throws SQLHeavy.Error {
      return this.fetch_int (this.field_index (field));
    }

    /**
     * Fetch a field from the result as a signed 64-bit integer
     *
     * @param field field index
     * @return the field value
     * @see get_int64
     * @see fetch
     */
    public virtual int64 fetch_int64 (int field = 0) throws SQLHeavy.Error {
      return this.fetch_with_type (typeof (int64), field).get_int64 ();
    }

    /**
     * Fetch a field from the result as a signed 64-bit integer by name
     *
     * @param field field name
     * @return the field value
     * @see fetch_int64
     * @see fetch
     */
    public virtual int64 get_int64 (string field) throws SQLHeavy.Error {
      return this.fetch_int64 (this.field_index (field));
    }

    /**
     * Fetch a field from the result as a double
     *
     * @param field field index
     * @return the field value
     * @see get_double
     * @see fetch
     */
    public virtual double fetch_double (int field = 0) throws SQLHeavy.Error {
      return this.fetch_with_type (typeof (double), field).get_double ();
    }

    /**
     * Fetch a field from the result as a double by name
     *
     * @param field field name
     * @return the field value
     * @see fetch_double
     * @see fetch
     */
    public virtual double get_double (string field) throws SQLHeavy.Error {
      return this.fetch_double (this.field_index (field));
    }

    /**
     * Fetch a field from the result as an array of bytes
     *
     * @param field field index
     * @return the field value
     * @see get_blob
     * @see fetch
     */
    public virtual uint8[] fetch_blob (int field = 0) throws SQLHeavy.Error {
      return ((GLib.ByteArray) this.fetch_with_type (typeof (GLib.ByteArray), field).get_boxed ()).data;
    }

    /**
     * Fetch a field from the result as an array of bytes by name
     *
     * @param field field name
     * @return the field value
     * @see fetch_blob
     * @see fetch
     */
    public virtual uint8[] get_blob (string field) throws SQLHeavy.Error {
      return this.fetch_blob (this.field_index (field));
    }

    /**
     * Fetch a field from the result as a timestamp
     *
     * @param field field index
     * @return the field value
     * @see get_time_t
     * @see fetch
     */
    public virtual time_t fetch_time_t (int field = 0) throws SQLHeavy.Error {
      return (time_t) this.fetch_with_type (typeof (int64), field).get_int64 ();
    }

    /**
     * Fetch a field from the result as a timestamp by name
     *
     * @param field field name
     * @return the field value
     * @see fetch_time_t
     * @see fetch
     */
    public virtual time_t get_time_t (string field) throws SQLHeavy.Error {
      return this.fetch_time_t (this.field_index (field));
    }
  }
}
