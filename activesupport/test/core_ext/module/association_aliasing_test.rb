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

  setup do
    ActiveRecord::Base.establish_connection({ adapter: "sqlite3", database: ":memory:" })
    @connection = ActiveRecord::Base.connection
    @connection.create_table(:patients)
    @connection.create_table(:tickets) { |t| t.integer :patient_id }
    @patient = Patient.create!
  end

  teardown do
    @connection.drop_table :patients
    @connection.drop_table :tickets
  end

  def test_association_alias_getter
    ticket = Ticket.create!(patient: @patient)
    assert_equal ticket.patient, ticket.person
  end

  def test_association_alias_setter
    ticket = Ticket.create!(person: @patient)

    assert_equal @patient, ticket.patient
  end
end
