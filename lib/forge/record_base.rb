#
# Record base class
#

module Forge
  class RecordBase
    @@columns = {}

    def self.table_name
      self.class.name.
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        upcase
    end

    def self.attribute(name, block)
      define_method(name.downcase) do
        @cache||={}
        @cache[name] = instance_eval &block if @cache[name].nil?
        @cache[name]
      end

      @@columns[self] ||= []
      @@columns[self] << name
    end

    def bulid_values
      @@columns[self.class].inject({}) do |ret, name|
        val = send(name.downcase)
        if val.nil?
          ret[name] =  'null'
        elsif val.is_a? String
          ret[name] =  "'#{val}'"
        elsif val.is_a? Time
          ret[name] =  "to_timestamp('#{val.strftime("%Y-%m-%d %H:%M:%S.000")}','YYYY-MM-DD HH24:MI:SS.FF')"
        else
          ret[name] = val
        end
        ret
      end
    end

    def output_insert()
      ret = bulid_values
      "insert into #{self.class.table_name} (#{ret.keys.join(',')})\n" +
        "values (#{ret.values.join(',')})"
    end

  end
end

