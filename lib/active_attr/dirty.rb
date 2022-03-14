require 'active_support'
require 'active_model/dirty'
require 'active_attr'

module ActiveAttr
  module Dirty
    extend ActiveSupport::Concern
    include ActiveModel::Dirty

    module ClassMethods
      def attribute!(name, options={})
        super(name, options)
        define_method("#{name}=") do |value|
          super(value)
          send("#{name}_will_change!") unless attributes[name].present? && value == attributes[name]
        end
      end
    end

    def attributes_and_changes
      attributes.select{ |attr, key| changed.include? attr }
    end
  end
end
