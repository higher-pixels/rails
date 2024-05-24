# frozen_string_literal: true

class ActiveStorage::NamedVariant # :nodoc:
  attr_reader :transformations, :preprocessed

  def initialize(transformations)
    @preprocessed = transformations[:preprocessed]
    @create_on_attach = transformations[:create_on_attach]
    @transformations = transformations.except(:preprocessed, :create_on_attach)
  end

  def preprocessed?(record)
    option(preprocessed, record)
  end

  def create_on_attach?(record)
    option(@create_on_attach, record)
  end

  private
    def option(value, record)
      case value
      when Symbol
        record.send(value)
      when Proc
        value.call(record)
      else
        value
      end
    end
end
