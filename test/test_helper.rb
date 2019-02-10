require File.expand_path('../../../../test/test_helper', __FILE__)

module NullValues
  def mroonga?
    Redmine::Database.mysql?
  end

  def null_string
    if mroonga?
      ""
    else
      nil
    end
  end

  def null_number
    if mroonga?
      0
    else
      nil
    end
  end

  def null_boolean
    if mroonga?
      false
    else
      nil
    end
  end

  def null_datetime
    if mroonga?
      connection = ActiveRecord::Base.connection
      db_time_zone =
        connection.execute("SHOW VARIABLES LIKE 'time_zone'").first[1]
      if db_time_zone == "SYSTEM"
        db_time_zone =
          connection.execute("SHOW VARIABLES LIKE 'system_time_zone'").first[1]
      end
      utc_offset = 0
      TZInfo::Timezone.all.each do |zone|
        period = zone.current_period
        if period.abbreviation == db_time_zone.to_sym
          utc_offset = period.offset.utc_offset
          break
        end
      end
      Time.at(0 - utc_offset).in_time_zone
    else
      nil
    end
  end
end
