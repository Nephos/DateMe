class UserDate < ActiveRecord::Base

  STATES = {
    "yes" => "bg-success",
    "no" => "bg-danger",
    "maybe" => "bg-warning"
  }
  DEFAULT_STATE = nil

  belongs_to :user
  belongs_to :meeting_date
  has_one :meeting, through: :meeting_date

  def self.mass_insert(rows, state=nil, time=nil)
    sql_query_mass_insert = mass_insert_sql(rows, state, time)
    # execute the request in a transaction
    return ActiveRecord::Base.transaction {
      UserDate.connection.execute sql_query_mass_insert
    }
  end

  def self.mass_insert_sql(rows, state, time)
    sql = <<SQL
INSERT INTO user_dates \
(\"user_id\", \"meeting_date_id\", \"updated_at\", \"created_at\", \"state\") \
VALUES #{mass_insert_sql_values(rows, state, time)}
SQL
    return sql
  end

  def self.mass_insert_sql_values(rows, state, time)
    # handle parameters
    time = sanitize mass_insert_sql_time(time)
    state = sanitize mass_insert_sql_state(state)
    # generate inserables values
    values = rows.map { |row|
      user_id = sanitize row[:user_id]
      meeting_date_id = sanitize row[:meeting_date_id]
      "(#{user_id}, #{meeting_date_id}, #{time}, #{time}, #{state})"
    }.join(", ")
    return values
  end

  def self.mass_insert_sql_time(time)
    time ||= Time.now
    raise RuntimeError, "time must be a `Time`" unless time.is_a?(Time)
    time = time.strftime("%Y-%m-%d %H:%M:%S")
    return time
  end

  def self.mass_insert_sql_state(state)
    state ||= DEFAULT_STATE
    raise RuntimeError, "state must be yes/no/maybe/nil" unless state.nil? || STATES.keys.include?(state)
    return state
  end

end
