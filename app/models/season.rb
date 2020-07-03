##
# == Schema Information
#
# Table name: seasons
#
# *id*::          <tt>integer, not null, primary key</tt>
# *name*::        <tt>string(255)</tt>
# *description*:: <tt>text</tt>
# *start_date*::  <tt>date</tt>
# *end_date*::    <tt>date</tt>
# *created_at*::  <tt>datetime, not null</tt>
# *updated_at*::  <tt>datetime, not null</tt>
# *slug*::        <tt>string(255)</tt>
#--
# == Schema Information End
#++
class Season < Event
  # Validate uniqueness on Event Subtype basis instead of on the event.
  # Otherwise, you cannot have two different types with the same slug.
  validates :slug, uniqueness: { case_sensitive: false }

  has_many :events

  def simultaneous_events
    return (Event.where('end_date >= ? and start_date <= ?', start_date, end_date).or(Event.where(season: self)).reorder('start_date ASC') - [self]).uniq
  end
end
