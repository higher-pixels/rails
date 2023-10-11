# frozen_string_literal: true

class Module
  # Allows you to make aliases for attributes, which includes
  # getter, setter, and a predicate.
  #
  #   class Content < ActiveRecord::Base
  #     # has a title attribute
  #   end
  #
  #   class Email < Content
  #     alias_attribute :subject, :title
  #   end
  #
  #   e = Email.find(1)
  #   e.title    # => "Superstars"
  #   e.subject  # => "Superstars"
  #   e.subject? # => true
  #   e.subject = "Megastars"
  #   e.title    # => "Megastars"
  def alias_attribute(new_name, old_name)
    # The following reader methods use an explicit `self` receiver in order to
    # support aliases that start with an uppercase letter. Otherwise, they would
    # be resolved as constants instead.
    module_eval <<-STR, __FILE__, __LINE__ + 1
      def #{new_name}; self.#{old_name}; end          # def subject; self.title; end
      def #{new_name}?; self.#{old_name}?; end        # def subject?; self.title?; end
      def #{new_name}=(v); self.#{old_name} = v; end  # def subject=(v); self.title = v; end
    STR
  end

  # Allows you to make aliases for associations, which includes
  # a getter and a setter.
  #
  #   class Patient < ActiveRecord::Base
  #     has_many :tickets
  #   end
  #
  #   class Ticket < ActiveRecord::Base
  #     belongs_to :patient
  #     alias_association :person, :patient
  #   end
  #
  #   You can get the value using the assocation alias:
  #
  #   p = Patient.find(1)
  #   t = Ticket.create!(patient: p)
  #   t.patient              # => #<Patient id: 1>
  #   t.person               # => #<Patient id: 1>
  #   t.patient == t.person  # true
  #
  #   You can also set the value using the assocation alias:
  #
  #   t = Ticket.create!(person: p)
  #
  #   This is also useful for polymorphic assiocations if you
  #   want to use a friendlier name:
  #
  #   class Ticket < ActiveRecord::Base
  #     belongs_to :ticketable, polymorphic: true
  #     alias_association :person, :ticketable
  #   end
  #
  #   These two examples are equivalent:
  #
  #   Ticket.create!(ticketable: p)
  #   Ticket.create!(person: p)
  def alias_association(alias_name, association_attribute)
    module_eval <<-STR, __FILE__, __LINE__ + 1
      def #{alias_name}; self.#{association_attribute}; end          # def person; self.patient; end
      def #{alias_name}=(v); self.#{association_attribute} = v; end  # def person=(v); self.patient = v; end
    STR
  end
end
