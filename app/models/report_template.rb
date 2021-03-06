# encoding: utf-8
require 'yaml'

class ReportTemplate < ActiveRecord::Base
  belongs_to :ac_filter_def

  def serialization_params=(value)
    if value.is_a? Hash
      value = Marshal.dump(value)
    end
    write_attribute :serialization_params, value
  end

  def serialization_params
    value = read_attribute :serialization_params
    begin
      value.nil? ? {} : Marshal.load(value)
    rescue TypeError

    end
  end

end
