class Hash
  # New Ruby 1.8.7+ constructor -- not documented, see redmine # 1385
  # <tt>Hash[[[:foo, :bar],[:hello, "world"]]] ==> {:foo => :bar, :hello => "world"}</tt>
  class << self
    def try_convert(x)
      return nil unless x.respond_to? :to_hash
      x.to_hash
    end unless method_defined? :try_convert
  end
  
  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  def default_proc=(proc)
    replace(Hash.new(&Backports.coerce_to(proc, Proc, :to_proc)).merge!(self))
  end unless method_defined? :default_proc=
end