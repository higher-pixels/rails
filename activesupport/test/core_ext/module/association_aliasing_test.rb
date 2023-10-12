# frozen_string_literal: true

require_relative "../../abstract_unit"
require "active_support/core_ext/module/aliasing"
require "active_record"

class AssociationAliasingTest < ActiveSupport::TestCase
  class Patient < ActiveRecord::Base
    has_many :tickets
  end

  class Ticket < ActiveRecord::Base
    belongs_to :patient
    alias_association :person, :patient
  end

  class Note < ActiveRecord::Base
    validates_presence_of :message
    alias_association :description, :message
  end

  setup do
    ActiveRecord::Base.establish_connection({ adapter: "sqlite3", database: ":memory:" })
    @connection = ActiveRecord::Base.connection
    @connection.create_table(:patients)
    @connection.create_table(:tickets) { |t| t.integer :patient_id }
    @connection.create_table(:notes) { |t| t.string :message }
    @patient = Patient.create!
  end

  teardown do
    @connection.drop_table :patients
    @connection.drop_table :tickets
    @connection.drop_table :notes
  end

  def test_association_alias_getter
    ticket = Ticket.create!(patient: @patient)
    assert_equal ticket.patient, ticket.person
  end

  def test_association_alias_setter
    ticket = Ticket.create!(person: @patient)
    assert_equal @patient, ticket.patient
  end

  def not_work_for_attribute
    assert Note.create!(message: "This should work.")
    assert_not Note.create!(description: "This should not work.")
  end
end
